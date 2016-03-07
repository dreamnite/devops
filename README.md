# Chef/Devops skill check
### License
<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br /><span xmlns:dct="http://purl.org/dc/terms/" property="dct:title">The Devops skill check</span> by <a xmlns:cc="http://creativecommons.org/ns#" href="https://github.com/dreamnite/devops" property="cc:attributionName" rel="cc:attributionURL">Jean-Paul Robinson</a> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.<br />Based on a work at <a xmlns:dct="http://purl.org/dc/terms/" href="https://github.com/dreamnite/devops" rel="dct:source">https://github.com/dreamnite/devops</a>.

## Introduction
This test is designed to check basic devops related skills. It is designed to assess basic understanding of a devops workflow, version control, and Chef. Ideal usage is for personal development or as a skill assessment for potential candidates.

It does assume a basic familiarity with the basic terms, and operation of an apache web server.

### Test version history

| Version | Author | Comments |
|---------|--------|----------|
| 1.0 | Jp Robinson | Initial test created

## Skills outline
The following skills will be tested:

  * Understanding of the git flow
    * Basic git operation (clone, commit)
    * Familiarity with forking, branching and pull requests.  
  * Test driven development
      * Ability to create a cookbook unit test with Chefspec
      * Ability to create a (passing) test kitchen
      * Ability to create automated integration tests (serverspec, bats, etc)
      * Understanding of foodcritic and basic linting
  * Chef cookbook creation
    * Ability to create a (working) recipe
    * Usage of node attributes to control output
    * Proper metadata maintenance
    * Berksfile creation

# The Test

The test begins here. Use of external documentation/resources is permissible and encouraged. There is no time limit, so relax, take a deep breath and let's begin:

## Section 1: The very basics
1. Fork this repository into a public repository under your github account
1. Clone this repository to your local workstation
1. Edit metadata.rb to include your name and email (feel free to obfuscate the email for spam prevention, or use a fake one)
1. Commit these changes with a descriptive message
1. Merge these changes back into your fork's master by any means.

## Section 2: The Cookbook

### 2.0 Requirements
Read the following section of requirements carefully, they form the basis for the rest of the test. Please note this is NOT the test, but the requirements for the next sections.

1. This cookbook should install and configure an apache web server
1. The webserver should listen on a configurable port, with a default of `8080`
1. The document root should be configurable and point to `/opt/mywebapp` by default.
1. The cookbook should include a node attribute `['devops']['test_url']` which should point to your fork of the repository on github by default.
1. The webserver should serve an index.html
1. The website should display the following text, replacing test_url with the value of `node['devops']['test_url']`:
  ```
  This website created by Chef for the Devops skill test located at <test_url>
  ```
1. Include the default recipe from https://github.com/dreamnite/include_me
1. Update metadata with all dependencies.
1. Create a Berksfile to include dependencies. Make sure you use a proper source.
1. Your cookbook should pass foodcritic with no errors. Sparing use of `~FC` syntax is acceptable, with an accompanying commented explanation.

### 2.1 Testing
A major part of the devops philosophy is test driven development. Therefore, we expect the cookbook to be able to be automatically tested. Items must fulfill the requirements as written, feel free to go above and beyond if you know how.

#### 2.1.0 Showing your work
1. Create a branch called `test_section`. Everything in section 2 should be done in this branch.

Please feel free to do commits as you would naturally in your own workflow. Your first commit to this branch does not need to be perfect, we all have git commits that say things like "Fixed typo", "Corrected syntax error", or even "Fixed thing I wrote at 2 am when I really needed sleep".

#### 2.1.1 Basic unit testing
1. Write a basic Chefspec test to ensure the default recipe compiles and converges with default values on a linux platform of your choice. The test should be stored in `spec/unit/recipes/default_spec.rb`

#### 2.1.2 Functional/integration tests
1. Create a kitchen.yml that sets up a linux machine (your choice of flavor) and runs the `devops::default` recipe, with default attributes. The kitchen-ec2 driver is preferred for ease of evaluation, but use of vagrant is also fine.

1. Write integration tests for each of the functional requirements (ie: items starting with the webserver or the website). Serverspec is preferred, but please use whatever kitchen compatible test suite you are most familiar with.

#### 2.1.3 Merge, do not delete
1. Merge this branch back into your master by any means. Do not delete the branch, it will be used to evaluate your work.


### 2.2 Cookbook, recipes, and attributes.
This next section will deal with your ability to write a valid Chef cookbook to the requirements above. Please read all directions carefully.

#### 2.2.0 Showing your work
1. Create a branch from master called `cookbook_section`. All your work for this section should be done in that branch. As before, commit naturally as you would in your normal workflow.

#### 2.2.1 Recipe creation
1. Using the requirements section as a guideline create recipe(s) to fulfill the requirements by any means. Please write your code naturally, commenting as normal. As long as the recipe meets the basic functional requirements, it should be ok.

#### 2.2.2 Merge, do not delete
1. Merge your branch back into your master by any means. Do not delete the branch.

## Section 3: Finalizing
1. To submit your work for evaluation, submit a pull request back to the original repository. As stated previously, do not delete the additional branches from your repository.


## Evaluation

Basic evaluation criteria for the test will be as follows:

* Section 1: Does `metadata.rb` in the master branch contain the correct items?

* Section 2.1: Does the `test_section` branch contain the requested items?
  * Do the tests cover the requirements as requested?
* Section 2.2: Does the `cookbook_section` branch exist?
  * Does the cookbook pass foodcritic?
  * Does it pass Chefspec?
  * Does it pass a kitchen run?
* Section 3 is evaluated as pass/fail. Lack of a pull request is an automatic failure :wink:
