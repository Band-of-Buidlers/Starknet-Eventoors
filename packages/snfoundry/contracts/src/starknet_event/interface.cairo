use starknet::ContractAddress;

#[starknet::interface]
pub trait IStarknetEvent<TContractState> {
    // Getters
    fn event_ID(self: @TContractState) -> u256;
    fn event_name(self: @TContractState) -> ByteArray;
    fn event_start(self: @TContractState) -> u64;
    fn event_end(self: @TContractState) -> u64;
    fn event_location(self: @TContractState) -> ByteArray;
    fn event_metadata_uri(self: @TContractState) -> ByteArray;

    // Setters
    fn register(ref self: TContractState);
    fn check_in_attendee(ref self: TContractState, attendee: ContractAddress);
}