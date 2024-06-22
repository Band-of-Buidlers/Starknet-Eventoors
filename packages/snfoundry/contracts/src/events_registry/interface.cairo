use starknet::ContractAddress;

#[starknet::interface]
pub trait IEventsRegistry<TContractState> {
    //? GETTER FUNCTIONS
    // fn get(self: @TContractState) -> u128; //? getter fn example
    fn total_events(self: @TContractState) -> u256;
    fn address_of_event(self: @TContractState, event_id: u256) -> ContractAddress;
    fn nber_of_events_published_by_organizer(self: @TContractState, organizer: ContractAddress) -> u256;
    fn event_of_owner_by_index(
        self: @TContractState, owner: ContractAddress, event_index: u256
    ) -> ContractAddress;

    //? SETTER FUNCTIONS
    // fn set(ref self: TContractState, x: u128);//? setter fn example
    fn publish_new_event(
        ref self: TContractState,
        owner: ContractAddress,
        name: ByteArray,
        start_time: u64,
        end_time: u64,
        location: ByteArray,
        // CID: Array<felt252>,
        max_capacity: u64,
        // event_metadata_uri: ByteArray,
    ) -> ContractAddress;
}