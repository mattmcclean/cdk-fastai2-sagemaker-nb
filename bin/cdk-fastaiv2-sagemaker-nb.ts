#!/usr/bin/env node
import 'source-map-support/register';
import * as cdk from '@aws-cdk/core';
import { CdkFastaiv2SagemakerNbStack } from '../lib/cdk-fastaiv2-sagemaker-nb-stack';

const app = new cdk.App();
new CdkFastaiv2SagemakerNbStack(app, 'CdkFastaiv2SagemakerNbStack');
