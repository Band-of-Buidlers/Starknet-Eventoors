// #[starknet::interface]
// trait IEventsRegistry<TContractState> {
//     // Getters
//     // fn example1(self: @TContractState) -> u256;

//     // Setters
//     // fn example2(ref self: TContractState);
// }


#[starknet::contract]
mod EventsRegistry {
    use contracts::events_registry::interface::IEventsRegistry;
    use core::traits::TryInto;
    use openzeppelin::access::ownable::OwnableComponent;
    use openzeppelin::upgrades::UpgradeableComponent;
    use openzeppelin::upgrades::interface::IUpgradeable;
    use openzeppelin::utils::serde::SerializedAppend;
    use starknet::syscalls::deploy_syscall;
    use starknet::{ClassHash, ContractAddress};
    use starknet::{get_caller_address,};

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
        fn total_events(self: @ContractState) -> u256 {
            self.total_events.read()
        }

        fn address_of(self: @ContractState, event_id: u256) -> ContractAddress {
            self.events_addresses.read(event_id)
        }

        fn nber_of_events_published_by(self: @ContractState, user: ContractAddress) -> u256 {
            self.users_totals.read(user)
        }

        fn event_of_owner_by_index(
            self: @ContractState, owner: ContractAddress, event_index: u256
        ) -> ContractAddress {
            assert!(event_index > 0, "index cannot be 0 (first event_index = 1)");
            assert!(
                event_index <= self.nber_of_events_published_by(owner), "event_index is too high"
            );

            self.users_events_mapping.read((owner, event_index))
        }

        //
        // WRITE FUNCTIONS (Setters)
        //
        fn publish_new_event(
            ref self: ContractState, name: ByteArray, // description: ByteArray,
            start: u64, end: u64,
        // stake_amount: u256,
        ) -> ContractAddress {
            let class_hash = EVENT_V01_FELT.try_into().unwrap();
            let contract_address_salt: felt252 = self
                .total_events()
                .try_into()
                .unwrap(); // I assume that `salt` needs to be different everytime this function is called
            let event_ID = self.total_events() + 1;
            let creator = get_caller_address();
            let deploy_from_zero: bool =
                false; // A flag that determines whether the deployer’s address affects the computation of the contract address. When not set, or when set to FALSE, the caller address is used as the new contract’s deployer address. When set to TRUE, 0 is used.

            let mut calldata_arr = array![];

            calldata_arr.append_serde(event_ID);
            calldata_arr.append_serde(name);
            // calldata_arr.append_serde(description);
            calldata_arr.append_serde(start);
            calldata_arr.append_serde(end);
            calldata_arr.append_serde(creator);
            let calldata: Span<felt252> = calldata_arr.span();

            let (deployed_event_contract, _) = deploy_syscall(
                class_hash, contract_address_salt, calldata, deploy_from_zero
            )
                .unwrap();
            return deployed_event_contract;
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
