targetScope = 'subscription'

param az_policy_definition_name string
param az_policy_definition_description string = 'Azure OpenAI provisioned managed resources disallowed'

resource az_policy_definition 'Microsoft.Authorization/policyDefinitions@2020-03-01' = {
    name: az_policy_definition_name
    properties: {
        policyType: 'Custom'
        mode: 'All'
        description: az_policy_definition_description
        displayName: az_policy_definition_description
        policyRule: {
            if: {
                    field: 'Microsoft.CognitiveServices/accounts/deployments/sku.name'
                    equals: 'ProvisionedManaged'
            }
            then: {
                effect: 'deny'
            }
        }
    }
}

resource az_policy_definition_assignment 'Microsoft.Authorization/policyAssignments@2023-04-01' = {
    name: az_policy_definition_name
    properties: {
      policyDefinitionId: az_policy_definition.id
      description: 'Policy assignment to ${az_policy_definition_description}'
      displayName: 'Policy assignment to ${az_policy_definition_description}'
      nonComplianceMessages: [
        {
          message: az_policy_definition_description
        }
      ]
    }
  }
