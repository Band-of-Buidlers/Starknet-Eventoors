"use client";

const pinataSDK = require("@pinata/sdk");
const { PINATA_API_KEY, PINATA_SECRET_KEY } = process.env;
const pinata = new pinataSDK(PINATA_API_KEY, PINATA_SECRET_KEY);
const fs = require("fs");

import React from "react";
import SimpleEventForm from "./_components/SimpleEventForm";
const CreateEvent = () => {
  return (
    <div>
      <h1>CreateEvent</h1>
      <SimpleEventForm />
    </div>
  );
};

export default CreateEvent;
