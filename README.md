# RPF toolbox

A toolbox for conducting relative psychometric function analysis.

## Quick start
1. See `RPF_guide_workflow` for an overview of how to use the RPF toolbox
2. See `RPF_example_simple` for an example analysis script on a real data set

## Documentation
### Overall workflow
For an overview of how to use the toolbox, please consult `RPF_guide_workflow` (which can also be accessed in the Matlab prompt via `RPF_guide('workflow')` or `help RPF_guide_workflow`). This provides an overview of how to use the toolbox to set up an analysis pipeline starting from raw trial-level data and culminating with results and plots for RPF analysis across multiple conditions within a single subject. From that point, it is straightforward to conduct analyses for multiple subjects and perform statistical tests on the group-level results. `RPF_guide_workflow` also contains pointers to more detailed documentation for specific aspects of the analysis pipeline.

### Specific topics
A general listing of available high-level help documentation pertaining to various aspects of using the toolbox is provided by the function `RPF_guide(query)`, which prints documentation for a given `query` into the Matlab prompt. (These can also be viewed by opening files following the naming format `RPF_guide_{query}` where `{query}` corresponds to the appropriate text string.) Available `query` strings and corresponding topics are as follows:

#### General topics
- `'toolboxes'` - on toolboxes that enable full functionality for the RPF toolbox
- `'workflow'` - on the general workflow of using the RPF toolbox
- `'utilities'` - on utilities and helper functions in the RPF toolbox

#### Main structs used in the RPF toolbox
- `'trialData'` - on the `trialData` struct (specified by the user)
- `'info'` - on the `info` struct (partially specified by the user)
- `'constrain'` - on the `constrain` struct (specified by the user)
- `'data'` - on the `data` struct (produced by `RPF_get_F_data`)
- `'fit'` - on the `fit` struct (produced by `RPF_fit_F`)
- `'F'` - on the `F` struct (assembled in the toolbox workflow)
- `'R'` - on the `R` struct (produced by `RPF_get_R`)
- `'plotSettings'` - on the `plotSettings` struct (used with `RPF_plot`)

#### Secondary structs used in the RPF toolbox
- `'counts'` - on the counts struct (used for SDT analysis)
- `'padInfo'` - on cell padding used for computing the counts struct
- `'searchGrid'` - on the search grid used in PF fitting 

#### Functions
In addition to the `RPF_guide` family of documentation discussed above, most functions in the RPF toolbox come with extensive documentation that can be viewed with the Matlab `help` command.

## Example analysis scripts
The toolbox comes with a couple of example analysis scripts to demonstrate concrete examples of fully fleshed out analysis pipelines. 

- `RPF_example_simple` contains a simple predefined analysis on an example data set.
- `RPF_example_flexible` is a more detailed script that is set up in a way that allows one to quickly play with different analysis settings on the example data set.

## Required toolboxes for full functionality
Please note that the RPF toolbox requires the following toolboxes:
- [Palamedes toolbox](https://www.palamedestoolbox.org/)
- [Optimization toolbox](https://www.mathworks.com/products/optimization.html)
- [meta-d' toolbox](https://www.columbia.edu/~bsm2105/type2sdt/) (included in the `metad` folder of this repository)

While these toolboxes are not necessary for *every* way of using the RPF toolbox, they do enable core functionality:
- Palamedes toolbox enables working with many basic psychometric functions (see `RPF_get_PF_list('PFs_Palamedes')` for a listing) and performing MLE fits on PFs fitted to response probabilities
- optimization toolbox enables performing MLE fits on d' and meta-d'
- meta-d' toolbox enables meta-d' analysis

To check if the RPF toolbox can detect the presence of these supporting toolboxes in your setup, use the function `RPF_check_toolboxes`.

## Please cite this toolbox as related to the following publications
(as of September 2, 2024; watch this space for updates to the preprint/publication)

Maniscalco, B., Castaneda, O. G., Odegaard, B., Morales, J., Rajananda, S., Denison, R., & Peters, M. A. K. (2024, September 2). The relative psychometric function: a general analysis framework for relating psychological processes. https://doi.org/10.31234/osf.io/5qrjn

The RPF toolbox also depends on the Palamedes toolbox, so please ensure you also cite them according to instructions here: [https://www.palamedestoolbox.org/howtocite.html](https://www.palamedestoolbox.org/howtocite.html)
