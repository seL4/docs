---
toc: true
---
# seL4 and CAmkES tutorials


First make sure you have
[set up your machine](/GettingStarted#setting-up-your-machine).

## Prerequisites


The build dependencies for seL4 can be found in the
`Prerequisites.md`
([Click!](https://github.com/SEL4PROJ/sel4-tutorials/blob/master/Prerequisites.md))
file in the root of the SEL4-tutorials GIT repository.

## seL4 tutorials


These tutorials get you started with writing dynamic systems and
interacting directly with seL4 and our libraries.

### Get the code
```
mkdir sel4-tutorials-manifest
cd sel4-tutorials-manifest
repo init -u https://github.com/SEL4PROJ/sel4-tutorials-manifest -b refs/tags/sel4-tutorials-9.0.1
repo sync
```

If you want to check out the solutions:

```
mkdir sel4-tutorials-manifest
cd sel4-tutorials-manifest
repo init -u https://github.com/SEL4PROJ/sel4-tutorials-manifest -b refs/tags/sel4-solutions-9.0.1
repo sync
```

### Do the tutorials


The top of the source tree contains the kernel itself, and the tutorials are found in the subfolder: "`projects/sel4-tutorials`". The tutorial consists of some pre-written sample applications which have been deliberately half-written. You will be guided through filling in the missing portions, and thereby become acquainted with seL4. For each of the sample applications however, there is a completed solution that shows all the correct answers, as a reference.
When completing the tutorials you will be initialising and building your solutions with CMake. The general flow of completing a tutorial exercise involves:
```
# creating a build directory
mkdir tutorial_build
cd tutorial_build
# initialising the build directory with a tutorial exercise
../init --plat <platform> --tut <tutorial exercise>
# building the tutorial exercise
ninja
```

After initialising your build directory you will be setup with half-written source for you to complete. In your build directory you will find:

- The half-written sample applications are in the
        subfolder: `<tutorial exercise>/`. `<tutorial exercise>` being the name of the exercise your are completing. Your job is to fill these out.
- The completed sample applications showing the solutions to the
        tutorial challenges can be retrieved by initialsing a build directory with the `--solution` argument
        e.g. `../init --plat <platform> --tut <tutorial exercise> --solution`

* The slide presentations to guide you through the tutorials are in the following files:

  - `projects/sel4-tutorials/docs/seL4-Overview.pdf`: This
            is an overview of the design and thoughts behind seL4, and
            we strongly recommend you read it before starting
            the tutorials.
  - `projects/sel4-tutorials/docs/seL4-APILib-details.pdf`:
    This is the actual tutorial.

* Detailed explanations of each tutorial challenge:

  - [seL4 Tutorial 1](seL4_Tutorial_1)
  - [seL4 Tutorial 2](seL4_Tutorial_2)
  - [seL4 Tutorial 3](seL4_Tutorial_3)
  - [seL4 Tutorial 4](seL4_Tutorial_4)
  - [seL4 Timer tutorial](seL4_Timer_tutorial)
  - [seL4 MCS tutorial](seL4_RT_tutorial)

## CAmkES tutorials


These tutorials get you started with our component system CAmkES, which
is allows you to configure static systems through components. CAmkES
generates the glue code for interacting with seL4.

### Get the code
```
mkdir camkes-tutorials-manifest
cd camkes-tutorials-manifest
repo init -u https://github.com/SEL4PROJ/sel4-tutorials-manifest -b refs/tags/camkes-tutorials-3.4.0
repo sync
```

If you want to check out the solutions:

```
mkdir camkes-tutorials-manifest
cd camkes-tutorials-manifest
repo init -u https://github.com/SEL4PROJ/sel4-tutorials-manifest -b refs/tags/camkes-solutions-3.4.0
repo sync
```


### Do the tutorials


These tutorials work similarly to the SEL4 tutorials in that they are
guided by a slide presentation. There are half-completed sample
applications, with a set of slides giving instructions, with TASK
challenges once again. There are also completed sample solutions.

- [CAmkES Tutorial 0](CAmkES_Tutorial_0)
- [CAmkES Tutorial 1](CAmkES_Tutorial_1)
- [CAmkES Tutorial 2](CAmkES_Tutorial_2)
- [CAmkES Timer Tutorial](CAmkES_Timer_Tutorial)

More info:

- The half-written sample applications are created in your build directory, under the
        folder: `<tutorial-exercise>/` (where `<tutorial exercise>` is the name of the exercise your are completing).
- The solutions can be retrieved by initialising a build directory with the `--solution` argument
        eg: `../init --plat <platform> --tut <tutorial exercise> --solution`.
- The slide presentations to guide you through the tutorials are
        in this
        file: `projects/sel4-tutorials/docs/CAmkESTutorial.pdf`.

## What next?


You can try building and running [seL4test](../seL4Test)
