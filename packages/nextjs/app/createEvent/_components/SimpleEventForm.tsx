import { useState } from "react";
import { useScaffoldWriteContract } from "../../../hooks/scaffold-stark/useScaffoldWriteContract";

const SimpleEventForm = () => {
  const [eventName, setEventName] = useState("");

  const { writeAsync } = useScaffoldWriteContract({
    // TODO:
    // maybe either use the deploy script with our own contracts
    // so that Scaffold Stark makes them usable for its hooks,
    // or use starknet react hook instead of the current Scaffold stark hook?
    contractName: "EventsRegistry",
    functionName: "publish_new_event",
    args: [eventName],
    // options: { gas: 100000 },
  });

  const handleSubmit = async (e) => {
    e.preventDefault();
    console.log("Event Name:", eventName);
    console.log("type of eventName =", typeof eventName);
    console.log("eventName.length =", eventName.length);
    try {
      const result = await writeAsync();
      console.log("Transaction successful:", result);
    } catch (error) {
      console.error("Transaction failed:", error);
    }
  };

  return (
    <div style={{ padding: "20px" }}>
      <h1>Create a New Event</h1>
      <form onSubmit={handleSubmit}>
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
        </div>
        <button type="submit">Create Event</button>
      </form>
    </div>
  );
};

export default SimpleEventForm;
