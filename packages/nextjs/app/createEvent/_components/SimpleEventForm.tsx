import { useState } from "react";
import { useScaffoldWriteContract } from "../../../hooks/scaffold-stark/useScaffoldWriteContract";
import { useAccount } from "@starknet-react/core";

const SimpleEventForm = () => {
  const { account, address, status } = useAccount();
  const [eventName, setEventName] = useState("");
  const [startTime, setStartTime] = useState("");
  const [endTime, setEndTime] = useState("");
  // const
  const [L, setL] = useState("");
  const [maxCapacity, setMaxCapacity] = useState(0);

  const { writeAsync } = useScaffoldWriteContract({
    contractName: "EventsRegistry",
    functionName: "publish_new_event",
    args: [
      eventName,
      address,
      Date.parse(startTime) / 1000,
      Date.parse(endTime),
      L,
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

    const date = new Date(startTime);
    const start_in_sec = date.toLocaleDateString();

    try {
      const result = await writeAsync();
      console.log("Transaction successful:", result);
    } catch (error) {
      console.error("Transaction failed:", error);
    }
  };

  return (
    <div
      // style={{ padding: "20px" }}
      className="flex flex-col items-center justify-center min-h-screen mt-12"
    >
      <h1>Create a New Event</h1>

      <form onSubmit={handleSubmit} className="flex flex-col gap-4">
        <div>
          <label htmlFor="event-name">Event Name: </label>
          <input
            type="text"
            id="event-name"
            value={eventName}
            onChange={(e) => setEventName(e.target.value)}
            maxLength={60}
            required
          />
          <small>{eventName.length}/60 characters</small>

          <label htmlFor="start-time">Start Time: </label>
          <input
            type="date"
            id="start-time"
            value={startTime}
            onChange={(e) => setStartTime(e.target.value)}
            required
          />
          <label htmlFor="end-time">End Time: </label>
          <input
            type="date"
            id="end-time"
            value={endTime}
            onChange={(e) => setEndTime(e.target.value)}
            required
          />
          <label htmlFor="event-name">Location: </label>
          <input
            type="text"
            id="Location"
            value={L}
            onChange={(e) => setL(e.target.value)}
            maxLength={60}
            required
          />
          <label htmlFor="event-name">Max Capacity For Event: </label>
          <input
            type="number"
            id="event-name"
            value={maxCapacity}
            onChange={(e) => setMaxCapacity(e.target.value)}
            required
          />
          {/* <label htmlFor="event-name">Event Name: </label>
          <input
            type="text"
            id="event-name"
            value={eventName}
            onChange={(e) => setEventName(e.target.value)}
            maxLength={60}
            required
          />
          <label htmlFor="event-name">Event Name: </label>
          <input
            type="text"
            id="event-name"
            value={eventName}
            onChange={(e) => setEventName(e.target.value)}
            maxLength={60}
            required
          /> */}
        </div>
        <button type="submit">Create Event</button>
      </form>
    </div>
  );
};

export default SimpleEventForm;
