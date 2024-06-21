// import { useState } from "react";

// const SimpleEventForm = () => {
//   const [formData, setFormData] = useState({
//     event_name: "",
//     // description: "",
//     // start_date: "",
//   });

//   const handleChange = (e) => {
//     setFormData({
//       ...formData,
//       [e.target.name]: e.target.value,
//     });
//   };

//   const handleSubmit = (e) => {
//     e.preventDefault();
//     console.log("Event form submitted:", formData);
//     console.log("event name provided:", formData.event_name);

//     //TODO LATER: Add your form submission logic here
//   };

//   return (
//     <form onSubmit={handleSubmit}>
//       <div>
//         <label htmlFor="name">Name:</label>
//         <input
//           type="text"
//           id="name"
//           name="name"
//           value={formData.event_name}
//           onChange={handleChange}
//         />
//       </div>
//       {/* <div>
//         <label htmlFor="email">Email:</label>
//         <input
//           type="email"
//           id="email"
//           name="email"
//           value={formData.email}
//           onChange={handleChange}
//         />
//       </div>
//       <div>
//         <label htmlFor="message">Message:</label>
//         <textarea
//           id="message"
//           name="message"
//           value={formData.message}
//           onChange={handleChange}
//         />
//       </div> */}
//       <button type="submit">Submit</button>
//     </form>
//   );
// };

// export default SimpleEventForm;

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
