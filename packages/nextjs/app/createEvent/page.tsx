"use client";

import { StarknetProvider } from "./_components/starknet-provider";
const pinataSDK = require("@pinata/sdk");
const { PINATA_API_KEY, PINATA_SECRET_KEY } = process.env;
const pinata = new pinataSDK(PINATA_API_KEY, PINATA_SECRET_KEY);
const fs = require("fs");

import React from "react";
import SimpleEventForm from "./_components/SimpleEventForm";


const CreateEvent = () => {
  return (
    <StarknetProvider>
      <div>
        <h1>CreateEvent</h1>
        <SimpleEventForm />
      </div>
    </StarknetProvider>
  );
};

export default CreateEvent;
