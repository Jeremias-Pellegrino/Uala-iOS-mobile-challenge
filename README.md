
<!-- HELLO UALÁ -->
<a id="readme-top">

<div align="center">

![](https://images.ctfassets.net/6n252fx9hkkr/4pC2sp1c3LAFN8sbSxEAPi/4570c4aaee41ece2a44871f446c6df48/Logo_Uala_Horizontal.png "Uala")
	

<h3>Mobile challanege - Jeremias Pellegrino</h3>

</div>
</a>



<!-- ABOUT THE PROJECT -->
## About the project

The goal of this project, as outlined in the provided brief, is to evaluate the ability to build an iOS application capable of efficiently handling large datasets. The main focus was on creating a responsive, smooth user interface with fast search and filtering capabilities.

### Approach

The first step was to identify the most suitable solution for the core functionality, the search, considering the requirements of handling a large dataset while maintaining smooth performance and user experience. All the arrows pointed to **Trie**. Once the data structure was chosen, the next task was to code the logic that will optimize the search results and design views and connect them.


### Why Trie?

The Trie is a specialized data structure inherently designed for operations like prefix matching. It is particularly efficient for operations involving prefix searches, as it organizes strings hierarchically based on their characters. 


* Allows searching for elements that start with a given prefix in O(k) time, **where k is the length of the prefix**. It's ridicously fast, as it doesnt depends on the number of elements, which also ensures it doesn't have scalabilities caveats. Even considering the system builtin optizations for standart basic structures like Array or Dictionary, is significantly faster than:

	* Iterating through an entire list of strings (O(n)), especially for large datasets.
	* Using **BS** (binary search) O(1) <-> O(log(n))
	* **Dictionaries** O(1) are no suitable for this use case
	* Other (AVL/Red-Black Trees, Suffin indexing, Ternary search, etc.) 

Considering that in this project we are working with +200,000 items, **Trie** is the best fit.

### Develop overview and optimizations

* Architecture: I used SwiftUI with the MVVM pattern to ensure a clean separation of concerns and maximize view reusability.

* Data Loading Optimization: The data loading process was optimized by reducing redundant computations. Since the data couldn’t be processed in chunks, the most computationally intensive step was parsing and ordering the entire dataset before inserting it into the Trie.

* UI Optimization: To improve the responsiveness of the main screen, I implemented a system that holds references to the first N items to display. This system also supports user favorites.

### Notes/Considerations


#### Future improvements:

I explored the possibility of on-demand parsing and displaying of data to reduce memory usage (currently 230MB). However, due to the nature of the data, this approach doesn’t seem feasible. I plan to revisit this idea in my free time to satisfy my curiosity.

*The initial ordering might be improved by using a custom closure, or switching to an UnicodeScalars based-order approach to retrieve the first N elements on-demand.

#### I've aimed to adress current and next-possible use cases
* Retaining the selected item after an orientation switch.
* Caching large downloads to improve performance.
* Storing data on disk to address user reports of lost favorite locations.

