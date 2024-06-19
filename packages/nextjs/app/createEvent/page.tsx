"use client";
require('dot.env').config();
const pinataSDK = require('@pinata/sdk');
const { PINATA_API_KEY, PINATA_SECRET_KEY } = process.env;
const pinata = new pinataSDK(PINATA_API_KEY, PINATA_SECRET_KEY);
const fs = require('fs');

import React from 'react'
import SimpleForm from './_components/SimpleForm'
const CreateEvent = () => {

  

  return (
     
    <div>
      <h1>CreateEvent</h1>
    <SimpleForm />
    </div>
    
  );
};

export default CreateEvent