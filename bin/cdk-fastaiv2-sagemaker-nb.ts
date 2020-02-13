#!/usr/bin/env node
import 'source-map-support/register';
import * as cdk from '@aws-cdk/core';
import { Fastaiv2SagemakerNbStack } from '../lib/cdk-fastaiv2-sagemaker-nb-stack';

const app = new cdk.App();
new Fastaiv2SagemakerNbStack(app, 'CdkFastaiv2SagemakerNbStack');
