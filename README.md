# sfdx-mass-reassign-oppty Utility App
## Overview
Salesforce DX Project for the mini-app to allow Mass reassign opportunities without giving View/Modify All data permission to users.

## DX Project
This DX project intended to work in scratch org as well as to deploy to sandbox or production ORG.

## Lightning & VisualForce
This utility provide simple UI app in VisualForce and APEX to allow users to mass reassign opportunities. Support Lightning Design System by using `lightningStyleSheets="true"`.

## Reason for this utility
Lightning and several packages do support mass-reassign feature out of the box. However, users doing this action require super powers of Admin access or View and Modify All Data permission. This is not ideal or possible in many ORG situations.

Example is ORG where managers in call center cannot have View/Modify All data, it is resticted. But need to reassign Opportunities in mass to other agents or even outside their team in case person left or on vacation.

This utility provide this feature.

## Unit tests
Basic unit test is included in this repository. This test requires opportunity data and we used dev org with simplified requirements.
This may not be realistic for complex orgs with complex Opportunity process, custom field requirements, validations or reocrd types. Depending on your org Oppty complexity unit test will need ot be updated to match the ORG requirement.

## Dev, Build and Test
To deploy this project to scratch or dev org, clone the repository.

*NOTE: To deploy this app with ANT use this reopositoty [sf-mass-reassign-oppty](https://github.com/iandrosov/sf-mass-reassign-oppty)

```
git clone https://github.com/iandrosov/sfdx-mass-reassign-oppty.git

# Create scratch org
sfdx force:org:create -f config/project-scratch-def.json -a TestOrg


# Deploy code to scxratch org
sfdx foce:source:push

```

## Resources


## Description of Files and Directories

DX Project Directory

```
sfdx-mass-reassign-oppty
    /config
    /force-app
        /main
            /default
                /aura
                /classes
                /pages
```
Apex Class Files

```
MassReassignOppty.cls
MassReassignOppty.cls-meta.xml
MassReassignOpptyTest.cls
MassReassignOpptyTest.cls-meta.xml
```
Visual Force Page

```
MassReassignOppty.page
MassReassignOppty.page-meta.xml
```
## Issues

When the Owner of the opportunity need to be reassigned is Disabled user then search cannot find and set this user to get his opportunities to reassign.

Workaround

Instead of diactivating a user make it active nad freeze user. Then we can reassign his oportunities and deactivate.
