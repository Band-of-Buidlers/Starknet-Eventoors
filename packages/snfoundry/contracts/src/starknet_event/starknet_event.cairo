#[starknet::contract]
mod StarknetEvent {
    use openzeppelin::access::ownable::ownable::OwnableComponent::InternalTrait;
use contracts::starknet_event::interface::IStarknetEvent;
    use openzeppelin::access::ownable::OwnableComponent;
    use starknet::ContractAddress;
    use starknet::{get_block_timestamp, get_caller_address, get_contract_address};

    component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);

    #[abi(embed_v0)]
    impl OwnableImpl = OwnableComponent::OwnableImpl<ContractState>;
    impl OwnableInternalImpl = OwnableComponent::InternalImpl<ContractState>;

    #[storage]
    struct Storage {
        event_id: u256,
        name: ByteArray,
        start: u64,
        end: u64,
        location: ByteArray,
        registration_count: u64,
        max_capacity: u64,
        metadata_uri: ByteArray,
        // maybe add a checkin deadline time? Which we compare to the current get_block_timestamp??
        registered: LegacyMap::<ContractAddress, u8>,
        check_in: LegacyMap::<ContractAddress, bool>,
        #[substorage(v0)]
        ownable: OwnableComponent::Storage,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        OwnableEvent: OwnableComponent::Event,
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        event_ID: u256,
        name: ByteArray,
        start_time: u64,
        end_time: u64,
        location: ByteArray,
        registration_count: u64,
        max_capacity: u64,
        event_metadata_uri: ByteArray,
        owner: ContractAddress
    ) {
        self.ownable.initializer(owner);
    }

    #[abi(embed_v0)]
    impl IStarknetEventImpl of IStarknetEvent<ContractState> {
        
        //
        // READ FUNCTIONS (Getters)
        //

        fn event_ID(self: @ContractState) -> u256 {
            self.event_id.read()
        }

        fn event_name(self: @ContractState) -> ByteArray {
            self.name.read()
        }

        fn event_start(self: @ContractState) -> u64 {
            self.start.read()
        }

        fn event_end(self: @ContractState) -> u64 {
            self.end.read()
        }

        fn event_location(self: @ContractState) -> ByteArray {
            self.location.read()
        }

        fn event_registration_count(self: @ContractState) -> u64 {
            self.registration_count.read()
        }

        fn event_max_capacity(self: @ContractState) -> u64 {
            self.max_capacity.read()
        }

        fn event_metadata_uri(self: @ContractState) -> ByteArray {
            self.metadata_uri.read()
        }

        //
        // WRITE FUNCTIONS (Setters)
        //

        fn register(ref self: ContractState) {
            // TODO: First, create a `registered` LegacyMap in the contract's Storage
            // TODO: Also create a Storage variable for an eventual max_capacity of the event
            // TODO: Then, add a variable for the nber_of_registrations
            // TODO: allow user to register to the event only if:
            // they haven't already registered
            // +
            // self.max_capacity is > self.registrations

            // Initial checks to make sure there is still space and that the person hasn't already registered
            assert!(self.registration_count.read() < self.max_capacity.read(), "This event is sold out!");
            assert!(self.registered.read(get_caller_address()) == 0, "This user is already registered");

            let registree_address = get_caller_address();
            self.registered.write(registree_address, 1);
            let current_count = self.registration_count.read();
            self.registration_count.write(current_count + 1);
        }

        fn increase_event_capacity(ref self: ContractState, new_capacity: u64) {
            self.ownable.assert_only_owner();
            assert!(new_capacity > self.event_max_capacity(), "new capacity must be greater than current value");
            self.max_capacity.write(new_capacity);
        }

        fn check_in_attendee(ref self: ContractState, attendee: ContractAddress) {
            // THIS FUNCTION'S USE IS RESTRICTED TO THE OWNER OF THE EVENT
            self.ownable.assert_only_owner();

            // TODO: First, create a `check_in` LegacyMap in the contract's Storage
            // (to track the addresses of the people that did show up)

            // TODO: Then, update the `check_in` storage to true for the given attendee address here
            self.check_in.write(attendee, true);
        }

    }





}
