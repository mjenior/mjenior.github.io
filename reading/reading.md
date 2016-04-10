---
layout: page
title: Reading List
permalink: /reading/
image:
  feature: reading.jpg
  credit: 
  creditlink: 
comments: false
---

This page is a list interesting papers that I've recently read.  Check back for regular updates!

4/9/16 - [Waste Not, Want Not: Why Rarefying Microbiome Data Is Inadmissible](http://journals.plos.org/ploscompbiol/article/asset?id=10.1371%2Fjournal.pcbi.1003531.PDF)

	Abstract:	Current practice in the normalization of microbiome count data is
	inefficient in the statistical sense. For apparently historical reasons,
	the common approach is either to use simple proportions (which does not
	address heteroscedasticity) or to use rarefying of counts, even though
	both of these approaches are inappropriate for detection of
	differentially abundant species. Well-established statistical theory is
	available that simultaneously accounts for library size differences and
	biological variability using an appropriate mixture model. Moreover,
	specific implementations for DNA sequencing read count data (based on a
	Negative Binomial model for instance) are already available in RNA-Seq
	focused R packages such as edgeR and DESeq. Here we summarize the
	supporting statistical theory and use simulations and empirical data to
	demonstrate substantial improvements provided by a relevant mixture
	model framework over simple proportions or rarefying. We show how both
	proportions and rarefied counts result in a high rate of false positives
	in tests for species that are differentially abundant across sample
	classes. Regarding microbiome sample-wise clustering, we also show that
	the rarefying procedure often discards samples that can be accurately
	clustered by alternative methods. We further compare different Negative
	Binomial methods with a recently-described zero-inflated Gaussian
	mixture, implemented in a package called metagenomeSeq. We find that
	metagenomeSeq performs well when there is an adequate number of
	biological replicates, but it nevertheless tends toward a higher false
	positive rate. Based on these results and well-established statistical
	theory, we advocate that investigators avoid rarefying altogether. We
	have provided microbiome-specific extensions to these tools in the R
	package, phyloseq.

3/23/16 - [Quantifying Diet-Induced Metabolic Changes of the Human Gut Microbiome](http://www.cell.com/cell-metabolism/pdf/S1550-4131(15)00330-7.pdf)

	Abstract:
	The human gut microbiome is known to be associated with various human disorders, but a major
	challenge is to go beyond association studies and elucidate causalities. Mathematical modeling of the
	human gut microbiome at a genome scale is a useful tool to decipher microbe-microbe, diet-microbe and
	microbe-host interactions. Here, we describe the CASINO (Community And Systems-level INteractive
	Optimization) toolbox, a comprehensive computational platform for analysis of microbial communities
	through metabolic modeling. We first validated the toolbox by simulating and testing the performance
	of single bacteria and whole communities in vitro. Focusing on metabolic interactions between the
	diet, gut microbiota, and host metabolism, we demonstrated the predictive power of the toolbox
	in a diet-intervention study of 45 obese and overweight individuals and validated our predictions by
	fecal and blood metabolomics data. Thus, modeling could quantitatively describe altered fecal and serum
	amino acid levels in response to diet intervention.

3/8/16 - [An interactive reference framework for modeling a dynamic immune system](http://science.sciencemag.org/content/349/6244/1259425.full-text.pdf+html)

	Abstract:
	Immune cells function in an interacting hierarchy that coordinates the activities of various cell 
	types according to genetic and environmental contexts. We developed graphical approaches to construct 
	an extensible immune reference map from mass cytometry data of cells from different organs, incorporating 
	landmark cell populations as flags on the map to compare cells from distinct samples. The maps 
	recapitulated canonical cellular phenotypes and revealed reproducible, tissue-specific deviations. The 
	approach revealed influences of genetic variation and circadian rhythms on immune system structure, 
	enabled direct comparisons of murine and human blood cell phenotypes, and even enabled archival 
	fluorescence-based flow cytometry data to be mapped onto the reference framework. This foundational 
	reference map provides a working definition of systemic immune organization to which new data can be 
	integrated to reveal deviations driven by genetics, environment, or pathology.

2/8/16 - [Metabolic Model-Based Integration of Microbiome Taxonomic and Metabolomic Profiles Elucidates Mechanistic Links between Ecological and Metabolic Variation](http://elbo.gs.washington.edu/pub/metamod_neocker_msystems.pdf)

	Abstract:
	Multiple molecular assays now enable high-throughput profiling of the
	ecology, metabolic capacity, and activity of the human microbiome. However, to
	date, analyses of such multi-omic data typically focus on statistical associations, often
	ignoring extensive prior knowledge of the mechanisms linking these various facets
	of the microbiome. Here, we introduce a comprehensive framework to systematically
	link variation in metabolomic data with community composition by utilizing
	taxonomic, genomic, and metabolic information. Specifically, we integrate available
	and inferred genomic data, metabolic network modeling, and a method for predicting
	community-wide metabolite turnover to estimate the biosynthetic and degradation
	potential of a given community. Our framework then compares variation in predicted
	metabolic potential with variation in measured metabolites’ abundances to
	evaluate whether community composition can explain observed shifts in the community
	metabolome, and to identify key taxa and genes contributing to the shifts.
	Focusing on two independent vaginal microbiome data sets, each pairing 16S community
	profiling with large-scale metabolomics, we demonstrate that our framework
	successfully recapitulates observed variation in 37% of metabolites. Well-predicted
	metabolite variation tends to result from disease-associated metabolism. We further
	identify several disease-enriched species that contribute significantly to these predictions.
	Interestingly, our analysis also detects metabolites for which the predicted
	variation negatively correlates with the measured variation, suggesting environmental
	control points of community metabolism. Applying this framework to gut microbiome
	data sets reveals similar trends, including prediction of bile acid metabolite
	shifts. This framework is an important first step toward a system-level multi-omic integration
	and an improved mechanistic understanding of the microbiome activity
	and dynamics in health and disease.

2/2/16 - [Microbiota-Dependent Sequelae of Acute Infection Compromise Tissue-Specific Immunity.](http://www.ncbi.nlm.nih.gov/pubmed/26451485)

	Abstract:
	Infections have been proposed as initiating factors for inflammatory disorders; however, 
	identifying associations between defined infectious agents and the initiation of chronic 
	disease has remained elusive. Here, we report that a single acute infection can have dramatic 
	and long-term consequences for tissue-specific immunity. Following clearance of Yersinia 
	pseudotuberculosis, sustained inflammation and associated lymphatic leakage in the mesenteric 
	adipose tissue deviates migratory dendritic cells to the adipose compartment, thereby preventing 
	their accumulation in the mesenteric lymph node. As a consequence, canonical mucosal immune 
	functions, including tolerance and protective immunity, are persistently compromised. 
	Post-resolution of infection, signals derived from the microbiota maintain inflammatory mesentery 
	remodeling and consequently, transient ablation of the microbiota restores mucosal immunity. Our 
	results indicate that persistent disruption of communication between tissues and the immune system 
	following clearance of an acute infection represents an inflection point beyond which tissue 
	homeostasis and immunity is compromised for the long-term.

2/1/16 - [Coculture of Escherichia coli O157:H7 with a Nonpathogenic E. coli Strain Increases Toxin Production and Virulence in a Germfree Mouse Model.](http://www.ncbi.nlm.nih.gov/pubmed/26259815)

	Abstract:
	Escherichia coli O157:H7 is a notorious foodborne pathogen due to its low infectious dose and the 
	disease symptoms it causes, which include bloody diarrhea and severe abdominal cramps. In some cases, 
	the disease progresses to hemorrhagic colitis (HC) and hemolytic uremic syndrome (HUS), due to the 
	expression of one or more Shiga toxins (Stx). Isoforms of Stx, including Stx2a, are encoded within 
	temperate prophages. In the presence of certain antibiotics, phage induction occurs, which also 
	increases the expression of toxin genes. Additionally, increased Stx2 accumulation has been reported 
	when O157:H7 was cocultured with phage-susceptible nonpathogenic E. coli. This study characterized 
	an E. coli O157:H7 strain, designated PA2, that belongs to the hypervirulent clade 8 cluster. Stx2a 
	levels after ciprofloxacin induction were lower for PA2 than for the prototypical outbreak strains 
	Sakai and EDL933. However, during coculture with the nonpathogenic strain E. coli C600, PA2 produced 
	Stx2a levels that were 2- to 12-fold higher than those observed during coculture with EDL933 and Sakai, 
	respectively. Germfree mice cocolonized by PA2 and C600 showed greater kidney damage, increased Stx2a 
	accumulation in feces, and more visible signs of disease than mice given PA2 or C600 alone. These data 
	suggest one mechanism by which microorganisms associated with the colonic microbiota could enhance the 
	virulence of E. coli O157:H7, particularly a subset of clade 8 strains.

2/1/16 - [Reverse Ecology: From Systems to Environments and Back](http://elbo.gs.washington.edu/pub/re_levy_aemb.pdf)

	Abstract:
	The structure of complex biological systems reflects not only their
	function but also the environments in which they evolved and are adapted to. Reverse
	Ecology—an emerging new frontier in Evolutionary Systems Biology—aims
	to extract this information and to obtain novel insights into an organism’s ecology.
	The Reverse Ecology framework facilitates the translation of high-throughput
	genomic data into large-scale ecological data, and has the potential to transform
	ecology into a high-throughput field. In this chapter, we describe some of the
	pioneering work in Reverse Ecology, demonstrating how system-level analysis of
	complex biological networks can be used to predict the natural habitats of poorly
	characterized microbial species, their interactions with other species, and universal
	patterns governing the adaptation of organisms to their environments. We further
	present several studies that applied Reverse Ecology to elucidate various aspects
	of microbial ecology, and lay out exciting future directions and potential future
	applications in biotechnology, biomedicine, and ecological engineering.

2/1/16 - [Genome scale models of yeast: towards standardized evaluation and consistent omic integration](http://pubs.rsc.org/en/content/articlepdf/2015/ib/c5ib00083a)

	Abstract:
	Genome scale models (GEMs) have enabled remarkable advances in systems biology, acting as functional
	databases of metabolism, and as scaffolds for the contextualization of high-throughput data. In the case of
	Saccharomyces cerevisiae (budding yeast), several GEMs have been published and are currently used for
	metabolic engineering and elucidating biological interactions. Here we review the history of yeast’s GEMs,
	focusing on recent developments. We study how these models are typically evaluated, using both
	descriptive and predictive metrics. Additionally, we analyze the different ways in which all levels of omics
	data (from gene expression to flux) have been integrated in yeast GEMs. Relevant conclusions and current
	challenges for both GEM evaluation and omic integration are highlighted.

2/1/16 - [The Last Word: Books as a Statistical Metaphor for Microbial Communities](http://handelsmanlab.sites.yale.edu/sites/default/files/LastWord.pdf)

	Abstract:
	Microbial communities contain unparalleled complexity, making
	them difficult to describe and compare. Characterizing this complexity
	will contribute to understanding the ecological processes
	that drive microbe-host interactions, bioremediation, and biogeochemistry.
	Moreover, an estimate of species richness will provide an
	indication of the completeness of a community profile. Such estimates
	are difficult, however, because community structure rarely fits
	a well-defined distribution. We present a model based on the word
	usage in books to illustrate the power of statistical tools in describing
	microbial communities and suggesting biological hypotheses. The
	model also generates data to test these methods when there are insufficient
	data in the literature. For example, by simulating the word
	distribution in books, we can predict the number of words that must
	be read to estimate the size of the vocabulary used to write the book.
	Combined with other models that have been used to make inaccessible
	problems tractable, our book model offers a unique approach
	to the complex problem of describing microbial diversity