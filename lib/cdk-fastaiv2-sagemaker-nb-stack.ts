import * as cdk from '@aws-cdk/core';
import { SageMakerNotebook } from '../lib/sagemakernb';
import fs = require('fs');

export class Fastaiv2SagemakerNbStack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    const instanceType = new cdk.CfnParameter(this, 'InstanceType', {
      type: 'String',
      description : 'Enter the SageMaker Notebook instance type',
      default: this.node.tryGetContext('instanceType') ? this.node.tryGetContext('instanceType') : 'ml.p2.xlarge',
      allowedValues: [ 'ml.p3.2xlarge', 'ml.p2.xlarge' ],
    });

    const volumeSize = new cdk.CfnParameter(this, 'VolumeSize', {
      type: 'Number',
      description : 'Enter the size of the EBS volume attached to the notebook instance',
      default: this.node.tryGetContext('volumeSize') ? this.node.tryGetContext('volumeSize') : 50,
      minValue: 5,
      maxValue: 17592,
    });    

    // The code that defines your stack goes here
    /** Create the SageMaker notebook instance */
    new SageMakerNotebook(this, 'Fastai2SagemakerNotebook', {
      name: 'fastai-v4',
      instanceType: instanceType.valueAsString,
      onCreateScript: fs.readFileSync('scripts/onCreate.sh', 'utf8').toString(),
      onStartScript: fs.readFileSync('scripts/onStart.sh', 'utf8').toString(),
      volumeSize: volumeSize.valueAsNumber,
      defaultCodeRepository: "https://github.com/fastai/course-v4",
    });    
  }
}
