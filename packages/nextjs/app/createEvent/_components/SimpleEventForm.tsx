import { useState } from "react";
import { useScaffoldWriteContract } from "../../../hooks/scaffold-stark/useScaffoldWriteContract";
import { useAccount } from "@starknet-react/core";

const SimpleEventForm = () => {
  const { account, address, status } = useAccount();
  const [eventName, setEventName] = useState("");
  const [startTime, setStartTime] = useState("");
  const [endTime, setEndTime] = useState("");
  const [eventLocation, setEventLocation] = useState("");
  const [maxCapacity, setMaxCapacity] = useState(0);

  const { writeAsync } = useScaffoldWriteContract({
    contractName: "EventsRegistry",
    functionName: "publish_new_event",
    args: [
      address,
      eventName,
      Date.parse(startTime) / 1000,
      Date.parse(endTime) / 1000,
      eventLocation,
      maxCapacity,
    ],
    // options: { gas: 100000 },
  });

  const handleSubmit = async (e) => {
    e.preventDefault();
    console.log("Event Name:", eventName);
    console.log("type of eventName =", typeof eventName);
    console.log("eventName.length =", eventName.length);
    console.log("logged in user address =", address);
    console.log("startTime type =", typeof startTime);
    console.log("startTime =", startTime);

    // const date = new Date(startTime);
    // const start_in_sec = date.toLocaleDateString();

    try {
      const result = await writeAsync();
      console.log("Transaction successful:", result);
    } catch (error) {
      console.error("Transaction failed:", error);
    }
  };

  return (
    <div className="flex flex-col items-center justify-center min-h-screen mt-12 p-6">
      <h1 className="text-2xl font-bold mb-6">Create a New Event</h1>

      <form
        onSubmit={handleSubmit}
        className="flex flex-col gap-4 bg-white p-6 rounded shadow-md w-full max-w-lg"
      >
        <div className="mb-4">
          <label
            htmlFor="event-name"
            className="block text-gray-700 text-sm font-bold mb-2"
          >
            Event Name:
          </label>
          <input
            type="text"
            id="event-name"
            value={eventName}
            onChange={(e) => setEventName(e.target.value)}
            maxLength={60}
            required
            className="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
          />
          <small className="text-gray-500">
            {eventName.length}/60 characters
          </small>
        </div>

        <div className="mb-4">
          <label
            htmlFor="start-time"
            className="block text-gray-700 text-sm font-bold mb-2"
          >
            Start Time:
          </label>
          <input
            type="date"
            id="start-time"
            value={startTime}
            onChange={(e) => setStartTime(e.target.value)}
            required
            className="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
          />
        </div>

        <div className="mb-4">
          <label
            htmlFor="end-time"
            className="block text-gray-700 text-sm font-bold mb-2"
          >
            End Time:
          </label>
          <input
            type="date"
            id="end-time"
            value={endTime}
            onChange={(e) => setEndTime(e.target.value)}
            required
            className="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
          />
        </div>

        <div className="mb-4">
          <label
            htmlFor="event-location"
            className="block text-gray-700 text-sm font-bold mb-2"
          >
            Location:
          </label>
          <input
            type="text"
            id="Location"
            value={eventLocation}
            onChange={(e) => setEventLocation(e.target.value)}
            maxLength={60}
            required
            className="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
          />
        </div>

        <div className="mb-4">
          <label
            htmlFor="event-capacity"
            className="block text-gray-700 text-sm font-bold mb-2"
          >
            Max Capacity For Event:
          </label>
          <input
            type="number"
            id="event-capacity"
            value={maxCapacity}
            // onChange={(e) => setMaxCapacity(BigInt(e.target.value))}
            onChange={(e) => setMaxCapacity(Number(e.target.value))}
            required
            className="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
          />
        </div>

        <button
          type="submit"
          className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
        >
          Create Event
        </button>
      </form>
    </div>
  );
};

export default SimpleEventForm;
