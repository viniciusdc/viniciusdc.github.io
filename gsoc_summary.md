# GSOC 2020 Work product submission.

## Summary of GSoC project with conda-forge (NumFocus)

### Introduction
  Throughout this Google Summer of code project I, along with my mentors, aimed to improve the conda-forge "auto-tick, by splitting  bot versions update cron job from the main environment, more specifically, separating the version updates structure to its own microservice. Which in return, improved to a more organic bot ecosystem, not only lessening the burden to the original main process, but also granting the bot team a more versatile way to track the packages version datas, and consecutively it's respective issues.

### What is conda-forge
  Conda-forge, an umbrella project of NumFOCUS, is a community effort that provides conda packages for a wide range of software, building and distributing packages, specialized in the hard-to-build or unique packages that often arise in a scientific computing context [1]:(citar https://numfocus.org/project/conda-forge) . The conda-forge ecosystem is fully structured around automation, the "auto-tick" bot plays an important role in the automatic maintenance of conda-forge packages, allowing the maintainers to build packages for different systems architectures, as also keeping their packages up-to-date automatically, and ensuring a high level of quality.


### How, it works ?
  Currently when a package passes by the auto tick bot, it’s information is processed and updated by calling some specific routines, one of these is the version update process. Its main goal is the requisition of every new version for the packages we currently have, getting this information using the sources that are provided for each package in our feedstock, and then load this information at the respective node inside our graph data structure, which then enable the various others services of the bot to update the package, refactor or initane a specific routine, for example a Migrator process.
	Originally, the environment for this process was defined inside one of the main services of the bot, not only that, but the updates also occurred inside the current computation of the graph. 

 %%% Here comes an image
 
So, the fundamental idea for this project  is to move the data structures used to update the packages to another repo with a separate process, not interfering directly with the graph and the others bot microservices, for instance the Migrations. We should than have a new environment for this process, in a much cleaner way

 %%% Here comes an image

As we can see, the idea is quite valuable and simplistic, even though not only there is a bigger change into the update versions code, as now should not bump any information inside the graph structure while loading the versions but also, as we actually are performing these evaluation outside the main process asynchronously, we now need another microprocesses to get this data and insert back to the graph to perform the other process.


### The proposed updates
  
  * ### Optional

### The new code workflow

### Conclusion

### Future work

### Acknowledgements
