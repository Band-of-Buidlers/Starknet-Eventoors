#[starknet::contract]
mod EventsRegistry {
    use contracts::events_registry::interface::IEventsRegistry;
    use openzeppelin::access::ownable::OwnableComponent;
    use openzeppelin::upgrades::UpgradeableComponent;
    use openzeppelin::upgrades::interface::IUpgradeable;
    use openzeppelin::utils::serde::SerializedAppend;
    use starknet::syscalls::deploy_syscall;
    use starknet::{ClassHash, ContractAddress};
    use starknet::{get_caller_address,};
    use core::traits::TryInto;
    
    const STARKNET_EVENT_CLASS_HASH: felt252 = 0x0294637156f038edb584c84137f659a1c513764890c231b785f3548a03065fc0;
    
    component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);
    component!(path: UpgradeableComponent, storage: upgradeable, event: UpgradeableEvent);

    #[abi(embed_v0)]
    impl OwnableImpl = OwnableComponent::OwnableImpl<ContractState>;
    impl OwnableInternalImpl = OwnableComponent::InternalImpl<ContractState>;
    impl UpgradeableInternalImpl = UpgradeableComponent::InternalImpl<ContractState>;

    #[storage]
    struct Storage {
        total_events: u256,
        events_addresses: LegacyMap<u256, ContractAddress>,
        users_totals: LegacyMap<ContractAddress, u256>,
        users_events_mapping: LegacyMap<(ContractAddress, u256), ContractAddress>,
        #[substorage(v0)]
        ownable: OwnableComponent::Storage,
        #[substorage(v0)]
        upgradeable: UpgradeableComponent::Storage,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        OwnableEvent: OwnableComponent::Event,
        #[flat]
        UpgradeableEvent: UpgradeableComponent::Event,
    }

    #[constructor]
    fn constructor(ref self: ContractState, owner: ContractAddress) {
        self.ownable.initializer(owner);
    }


    #[abi(embed_v0)]
    impl EventsRegistryImpl of IEventsRegistry<ContractState> {
        //
        // READ FUNCTIONS (Getters)
        //

        // Total number of events available on the site
        fn total_events(self: @ContractState) -> u256 {
            self.total_events.read()
        }

        // Retrieves the address of an event
        fn address_of_event(self: @ContractState, event_id: u256) -> ContractAddress {
            assert!(event_id <= self.total_events(), "given event_id does not exist");
            self.events_addresses.read(event_id)
        }
        
        // Number of events an organizer has published using their deployed address
        fn nber_of_events_published_by_organizer(self: @ContractState, organizer: ContractAddress) -> u256 {
            self.users_totals.read(organizer)
        }

        fn event_of_owner_by_index(
            self: @ContractState, owner: ContractAddress, event_index: u256
        ) -> ContractAddress {
            assert!(event_index > 0, "index cannot be 0 (first event_index = 1)");
            assert!(
                event_index <= self.nber_of_events_published_by_organizer(owner), "event_index is too high"
            );

            self.users_events_mapping.read((owner, event_index))
        }

        //
        // WRITE FUNCTIONS (Setters)
        //
        fn publish_new_event(
            ref self: ContractState,
            owner: ContractAddress,
            name: ByteArray,
            start_time: u64,
            end_time: u64,
            location: ByteArray,
            // CID: Array<felt252>,
            max_capacity: u64,
            // event_metadata_uri: ByteArray,
        ) -> ContractAddress {
            let class_hash: ClassHash = STARKNET_EVENT_CLASS_HASH.try_into().unwrap();

            let contract_address_salt: felt252 = self
                .total_events()
                .try_into()
                .unwrap(); // I assume that `salt` needs to be different everytime this function is called 

            let event_ID = self.total_events() + 1;
            let creator = get_caller_address();
            let deploy_from_zero: bool =
                false; // A flag that defines whether the deployer’s address affects the computation of the contract address. When not set, or when set to FALSE, the caller address is used as the new contract’s deployer address. When set to TRUE, 0 is used.

            let mut calldata_arr = array![];

            calldata_arr.append_serde(creator);
            calldata_arr.append_serde(event_ID);
            calldata_arr.append_serde(name);
            // calldata_arr.append_serde(description);
            calldata_arr.append_serde(start_time);
            calldata_arr.append_serde(end_time);
            calldata_arr.append_serde(location);
            calldata_arr.append_serde(max_capacity);
            
            let calldata: Span<felt252> = calldata_arr.span();

            // deploying the contract and creating a variable = its contract address
            let (deployed_event_contract, _) = deploy_syscall(
                class_hash, contract_address_salt, calldata, deploy_from_zero
            )
                .unwrap();

            // updating Storage variables with the newly created event
            self.total_events.write(event_ID);
            self.events_addresses.write(event_ID, deployed_event_contract);
            let index_of_event_for_creator = self.nber_of_events_published_by_organizer(creator) + 1;
            self.users_totals.write(creator, index_of_event_for_creator);
            self.users_events_mapping.write((creator, index_of_event_for_creator), deployed_event_contract);

            return deployed_event_contract; // maybe we won't need to return anything here.
        }
    }

    #[abi(embed_v0)]
    impl UpgradeableImpl of IUpgradeable<ContractState> {
        fn upgrade(ref self: ContractState, new_class_hash: ClassHash) {
            self.ownable.assert_only_owner();
            self.upgradeable._upgrade(new_class_hash);
        }
    }
}
