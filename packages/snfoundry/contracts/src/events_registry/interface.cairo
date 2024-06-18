use starknet::ContractAddress;

#[starknet::interface]
pub trait IEventsRegistry<TContractState> {
    //? GETTER FUNCTIONS
    // fn get(self: @TContractState) -> u128; //? getter fn example
    fn total_events(self: @TContractState) -> u256;
    fn address_of(self: @TContractState, event_id: u256) -> ContractAddress;
    fn nber_of_events_published_by(self: @TContractState, user: ContractAddress) -> u256;
    fn event_of_owner_by_index(
        self: @TContractState, owner: ContractAddress, event_index: u256
    ) -> ContractAddress;

    //? SETTER FUNCTIONS
    // fn set(ref self: TContractState, x: u128);//? setter fn example
    fn publish_new_event(
        ref self: TContractState, name: ByteArray, // description: ByteArray,
        start: u64, end: u64,
    // stake_amount: u256
    ) -> ContractAddress;
}