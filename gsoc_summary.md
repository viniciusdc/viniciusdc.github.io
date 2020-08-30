# GSOC 2020 Work product submission.

## Summary of GSoC project with conda-forge (NumFocus)

### Introduction
  Throughout this Google Summer of code ([GSoC](https://summerofcode.withgoogle.com/)) project I, along with my mentors, aimed to improve the conda-forge "auto-tick, by splitting  bot versions update cron job from the main environment, more specifically, separating the version updates structure to its own microservice. Which in return, improved to a more organic bot ecosystem, not only lessening the burden to the original main process, but also granting the bot team a more versatile way to track the packages version datas, and consecutively it's respective issues.

### What is conda-forge
  Conda-forge, an umbrella project of [NumFOCUS](https://numfocus.org/), is a [community](https://gitter.im/conda-forge/conda-forge.github.io) effort that provides conda packages for a wide range of software, building and distributing packages, specialized in the hard-to-build or unique packages that often arise in a scientific computing context [conda-forge](https://numfocus.org/project/conda-forge). The conda-forge ecosystem is fully structured around automation, the "auto-tick" bot plays an important role in the automatic maintenance of conda-forge packages, allowing the maintainers to build packages for different systems architectures, as also keeping their packages up-to-date automatically, and ensuring a high level of quality.


### How, it works ?
The conda-forge autotick bot is now a central part of the conda-forge ecosystem. Rougly speaking the bot tracks and updates the feedstocks in four steps:
   - Find the names of all feedstocks on conda-forge.
   - Compute the dependency graph of packages on conda-forge found in step 1.
   - Find the most recent version of each feedstock’s source code.
   - Open a PR into each out-of-date feedstock updating the meta.yaml for the most recent upstream release.
   
  Currently when a package passes by the auto tick bot, it’s information is processed and updated by calling some specific routines, one of these is the version update process. Its main goal is the requisition of every new version for the packages we currently have, getting this information using the sources that are provided for each package in our feedstock, and then load this information at the respective node inside our graph data structure, which then enable the various others services of the bot to update the package, refactor or initane a specific routine, for example a Migrator process.
	
  Originally, the environment for this process was defined inside one of the main services of the bot, not only that, but the updates also occurred inside the current computation of the graph. 

<p align="center">
  <img src="https://github.com/viniciusdc/viniciusdc.github.io/blob/viniciusdc-patch-3/img/old_eco.png" />
</p>
 
So, the fundamental idea for this project  is to move the data structures used to update the packages to another repo with a separate process, not interfering directly with the graph and the others bot microservices, for instance the Migrations. We should than have a new environment for this process, in a much cleaner way

<p align="center">
  <img src="https://github.com/viniciusdc/viniciusdc.github.io/blob/viniciusdc-patch-3/img/new_eco.png" />
</p>

As we can see, the idea is quite valuable and simplistic, even though not only there is a bigger change into the update versions code, as now should not bump any information inside the graph structure while loading the versions but also, as we actually are performing these evaluation outside the main process asynchronously, we now need another microprocesses to get this data and insert back to the graph to perform the other process.


### The proposed updates
  - Separate/upgrade the code that search for version updates  from the graph structure;
  - Create new a process on Circle CI to manage the new versions and bump then at a new folder/repository at GitHub;
  - Adapt the ‘make graph’ process to load the versions information from the new location and insert then at the graph;
  - Adapt the tests codes for the new scripts and functions;
  - Optimize minor parts of the new update versions code.
  * ## Optional
  	- As another improvement for the bot usage, a profiler decorator (with context manager) was implemented. [extra](https://github.com/regro/cf-scripts/pull/1131#pullrequestreview-474906393)

### The new code workflow
   Before starting with the modification an improved explanation about the update versions process shall be given. 
   
   First we load the graph (which is the fundamental structure for accommodating information about the feedstocks), once loaded, we search for every fedstock the information regarding its versions at their sources (which can be PyPi, ROS, NPM and so on). Then a special function called `get_latest_version` is responsible for the requisition of the new versions from the sources and `update_upstream_version` updates the information at the graph with the requested ones, this process comprehends the 'update version process', wich in this case is attached to the graph main structure.

<p align="center">
  <img src="https://github.com/viniciusdc/viniciusdc.github.io/blob/viniciusdc-patch-2/img/update_version_process.png" />
</p>

I will list the main features implemented along with links to the respective PR's where more details can be found about each of these features. In the end, there is a list with links pointing to the final scripts and codes modified during the project. 
The main issue for the project and the general discussion can be inspected here [issue 842](https://github.com/regro/cf-scripts/issues/842). The affected repositories can be found repectiviley here [cf-scripts](https://github.com/regro/cf-scripts), [cf-graph-countyfair](https://github.com/regro/cf-graph-countyfair) and [circle_worker](https://github.com/regro/circle_worker). 

   - To begin with, I had to read the graph (it is load the graph to inspect the attribute of each feedstock), then get the new versions and of course bump it to somewhere else to not interfere with the graph structure [#1](https://github.com/viniciusdc/viniciusdc.github.io/issues/1);
   - After this brief prelude of the code, I reached a more versatile code and approach that adapted the current code for the function that collects and requests the new versions (get_latest_version) and update the graph with those (update_upstream_versions), the main modification here also included a separation between the code that updates the versions (it is the actual computation) from the sources classes of the feedstocks. [#2](https://github.com/regro/cf-scripts/pull/1027);
   - Now we have a new script called `populate_update_versions` that collects the new versions and works without disrupting the graph directly. We can start running the new process and check the information been sended to the `versions` folder at `regro/cf-graph-countyfair` [repository](https://github.com/regro/cf-graph-countyfair/), the process will then be running inside a continuous integration system (Circle CI) [#3](https://github.com/regro/circle_worker/pull/61);
   - Due to the expensive time consuming usage of the actual and as every request of the sources new versions could be evaluated asynchronously inside the process I’ve added a pool feature to the update version code to increase the efficiency of the process [#4](https://github.com/regro/cf-scripts/pull/1049);
   - Once the new versions folder was ready with the feedstocks versions data, the next thing to do was work at the code that gathered that information and inserted back to the graph, we've opted to create the feature, called `update_nodes_with_new_versions` inside the current `make_graoh` function as it main role was already build and upgrade the graph structure with data. [#5](https://github.com/regro/cf-scripts/pull/1050);
   - As a matter of fact, we could also insert new utilities insethe the update_upstream_versions code to solve some issues [#6](https://github.com/regro/cf-scripts/pull/1073);
   - Finally we could proceed and switch the old update upstream version code with the new one, and set the new process to work altogether with the main bot processes [#7](https://github.com/regro/cf-scripts/pull/1075), as also CJ helped me solving some bugs and other issues with the code [#8](https://github.com/regro/cf-scripts/pull/1099).
   * ## Optional work
     - Also as a tool to inspect the bot process calls and memory usage, an Profiler (using the package [cProfiler](https://docs.python.org/3/library/profile.html)) was implemented. As a form to contend any issues and generally facilitated it's usage it was also Implemented using a context manager custom class to enable and disable the profiler. [#9](https://github.com/regro/cf-scripts/pull/1131)

   In conclusion I've created a new script called [`update-sources`](https://github.com/regro/cf-scripts/blob/master/conda_forge_tick/update_sources.py) where the sources classes are defined, the [`update_upstream_versions`](https://github.com/regro/cf-scripts/blob/master/conda_forge_tick/update_upstream_versions.py) was modified to get the necessary versions without interfering directly with the graph, [`make_graph`](https://github.com/regro/cf-scripts/blob/7a6ced3b7de53a97cfb07a730c61ad0e9d66e2cf/conda_forge_tick/make_graph.py#L229) was modified too, to get the new information regarding the `new_versions` and insert then at the graph during the appropriate time/process, and [`cli.xsh`](https://github.com/regro/cf-scripts/blob/7a6ced3b7de53a97cfb07a730c61ad0e9d66e2cf/conda_forge_tick/cli.xsh#L31) and [`config.yml`](https://github.com/regro/circle_worker/blob/fcc5e072b7470d662ea42403a5d8008d59561a27/.circleci/config.yml#L203) were update to enable the new process called `run_versions_update` to run on [Circle](https://app.circleci.com/pipelines/github/regro/circle_worker/24039/workflows/8f4ade61-eaa5-48b4-bf3b-33f741cbd0f1/jobs/43558).   
### Future work

During this Google Summer of Code project I have absolutely loved my time working with conda-forge. The community has been incredibly supportive and it is so rewarding to see these new features and improvements being running inside such big structures like conda-forge and the auto-tick bot. This provides great motivation to further develop new ideas for the community and also improve my background to handle even more interesting and challenging issues in the future .

Some identifiable improvements would be

   - Prepare a solid explanation for the functionality of the bot process and strucutras, like its correspondence with the Migrators and subordinate process like the PRs  managers;
   - Continue looking for improvements for the main bot process, as switching for better tools or mechanisms;
   - As also an enormous motivation to improve the automation characteristic of the bot, and enhance its process to facilitate the life for th mainteinres and the bot team in the future.

### Acknowledgements

First and foremost I would like to thank all my mentors CJ, Matthew and Filipe for all the help and advice they provided during the project, as well as for listening and answering (very often) my ideas and questions (there were plenty of those). Matthew helped me since the beginning to understand and familiarize with the bot structure and functionality, CJ has found lots of the initial errors and inconsistencies during the running and testing of the code implementations, as also, figured out various ways to follow or guide some of my ideas (sometimes I overthink too much). Filipe guided me inside the community, helped reading and correcting my posts, helping with the dashboards deadlines and giving me direction within the bot team, who's also requested from NumFOCUS funding for me to participate at the [Scipy 2020](https://www.scipy2020.scipy.org/), which allowed me to found inspiration to some aspects of my future career as Mathematician and programmer (see a [post](https://viniciusdc.github.io/events/2020/07/20/Scipy-2020.html) about my experiencies during the event). Finally the Google Summer of Code program, who provided the necessary funding so I could undertake this project  and have a wonderful experience within the open-source community.

 I truly believe this is one of the wonderful things about the project, an effort to bring people from various places around the globe and multi nationalities to discover, work, learn and to propagate scientific discoveries to everyone.
