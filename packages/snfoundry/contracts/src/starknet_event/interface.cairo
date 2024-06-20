use starknet::ContractAddress;

#[starknet::interface]
pub trait IStarknetEvent<TContractState> {
    // Getters
    fn event_ID(self: @TContractState) -> u256;
    fn event_name(self: @TContractState) -> ByteArray;
    fn event_start(self: @TContractState) -> u64;
    fn event_end(self: @TContractState) -> u64;
    fn event_location(self: @TContractState) -> ByteArray;
    fn event_registration_count(self: @TContractState) -> u64;
    fn is_registered(self: @TContractState, account: ContractAddress) -> bool;
    fn event_max_capacity(self: @TContractState) -> u64;
    fn amount_to_stake(self: @TContractState) -> u256;
    fn event_metadata_uri(self: @TContractState) -> ByteArray;

    // Setters

    // for Users
    fn stake_to_register(ref self: TContractState);
    

    // for Event Owner only
    fn increase_event_capacity(ref self: TContractState, new_capacity: u64);
    fn check_in_attendee(ref self: TContractState, attendee: ContractAddress);
}