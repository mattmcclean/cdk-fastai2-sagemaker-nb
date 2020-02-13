#!/usr/bin/env node
import cdk = require('@aws-cdk/core');
import iam = require('@aws-cdk/aws-iam');
import sagemaker = require('@aws-cdk/aws-sagemaker');

export interface SageMakerNotebookProps {

  readonly name: string;

  readonly role?: iam.IRole;

  readonly instanceType?: string;

  /** the path to the script that is run when sagemaker notebook created **/
  readonly onCreateScript?: string;
  
  /** the path to the script that is run when sagemaker notebook started **/
  readonly onStartScript?: string;

  readonly volumeSize?: number;

  readonly defaultCodeRepository?: string;
}

export class SageMakerNotebook extends cdk.Construct {

  public readonly name: string;

  public readonly role: iam.IRole;

  public readonly instanceType: string;

  public readonly notebookArn: string;

  constructor(parent: cdk.Construct, id: string, props: SageMakerNotebookProps) {
    super(parent, id);
  
    /** set the notebook name */
    this.name = props.name;

    /** Set the role from props else create a new Role */
    this.role = props.role ? props.role : new iam.Role(this, this.name + 'NotebookRole', {
      assumedBy: new iam.ServicePrincipal('sagemaker.amazonaws.com'),
      managedPolicies: [ iam.ManagedPolicy.fromAwsManagedPolicyName('AmazonSageMakerFullAccess') ]
    })

    /** set the instance type */
    this.instanceType = props.instanceType ? props.instanceType : "ml.t3.medium";

    /** Create the SageMaker notebook instance */
    const notebook = new sagemaker.CfnNotebookInstance(this, this.name + 'NotebookInstance', {
      notebookInstanceName: this.name,
      ...((props.onStartScript || props.onCreateScript) ? { lifecycleConfigName: new sagemaker.CfnNotebookInstanceLifecycleConfig(this, this.name + 'LifecycleConfig', {
        notebookInstanceLifecycleConfigName: this.name + 'LifecycleConfig',
        ...(props.onCreateScript ? { onCreate: [ { content: cdk.Fn.base64(props.onCreateScript) }]} : {}),
        ...(props.onStartScript ? { onStart: [ { content: cdk.Fn.base64(props.onStartScript) }]} : {}),
      }).notebookInstanceLifecycleConfigName} : {}),
      roleArn: this.role.roleArn,
      instanceType: this.instanceType,
      ...(props.volumeSize ? { volumeSizeInGb: props.volumeSize } : {} ),
      ...(props.defaultCodeRepository ? { defaultCodeRepository: props.defaultCodeRepository } : {}),
    });

    this.notebookArn = notebook.ref;
  }
}