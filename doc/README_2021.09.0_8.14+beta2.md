# Coq Platform 2021.09.0 providing Coq 8.14.0 10/2021 with a beta package pick

The [Coq proof assistant](https://coq.inria.fr) provides a formal language
to write mathematical definitions, executable algorithms, and theorems, together
with an environment for semi-interactive development of machine-checked proofs.

The [Coq Platform](https://github.com/coq/platform) is a distribution of the Coq
interactive prover together with a selection of Coq libraries and plugins.

The Coq Platform supports to install several versions of Coq (also in parallel).
This README file is for **Coq Platform 2021.09.0 with Coq 8.14.0**.
The README files for other versions are linked in the main [README](../README.md).

This version of Coq Platform 2021.09.0 includes Coq 8.14.0 from  10/2021. While the bundled Coq version is a **release**, Coq Platform is still **beta**. Several packages do not yet have a compatible version or might change. This version of Coq Platform is mostly intended for package maintainers. 

The Coq Platform supports four levels of installation extent:
**base**, **IDE**, **full** and **extended** and a few **optional** packages.
The sections below provide a short description of each level and the list of
packages included in each level. Packaged versions of the Coq Platform usually
contain the **extended** set with all optional packages.

**Note on non-free licenses:** The Coq Platform contains software with
**non-free licenses which do not allow commercial use without purchasing a license**,
notably the **coq-compcert** package. Please study the package licenses given
below and verify that they are compatible with your intended use in case you
plan to use these packages.

**Note on license information:**
The license information given below is obtianed from opam.
The Coq Platform team does no double check this information.

**Note on multiple licenses:** 
In case several licenses are given below, it is not clearly specified what this means.
It could mean that parts of the software use one license while other parts use another license.
It could also mean that you can choose between the given licenses.
Please clarify the details with the homepage of the package.

**Note:** The package list is also available as [CSV](PackageTable_2021.09.0_8.14+beta2.csv).

**Note:** Click on the triangle to show additional information for a package!

<br>

## **Coq Platform 2021.09.0 with Coq 8.14.0 "base level"**

The **base level** is mostly intended as a basis for custom installations using
opam and contains the following package(s):

<details>
  <summary><a href='https://coq.inria.fr/'>coq.8.14.0</a>
(8.14.0) Formal proof management system</summary>
  <dl>
    <dt><b>authors</b></dt><dd>The Coq development team, INRIA, CNRS, and contributors.</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/LGPL-2.1-only.html" target="_blank">LGPL-2.1-only</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://coq.inria.fr/'>homepage</a>)
      (<a href='https://github.com/coq/coq/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/coq/coq.8.14.0/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>The Coq proof assistant provides a formal language to writenmathematical definitions, executable algorithms, and theorems, togethernwith an environment for semi-interactive development of machine-checkednproofs. Typical applications include the certification of properties of programmingnlanguages (e.g., the CompCert compiler certification project and thenBedrock verified low-level programming library), the formalization ofnmathematics (e.g., the full formalization of the Feit-Thompson theoremnand homotopy type theory) and teaching.</dd>
  </dl>
</details>

<br>

## **Coq Platform 2021.09.0 with Coq 8.14.0 "IDE level"**

The **IDE level** adds an interactive development environment to the **base level**.

For beginners, e.g. following introductory tutorials, this level is usually sufficient.
If you install the **IDE level**, you can later add additional packages individually
via `opam install <package-name>` or rerun the Coq Platform installation script
and choose the full or extended level.

The **IDE level** contains the following package(s):

<details>
  <summary><a href='https://coq.inria.fr/'>coqide.8.14.0</a>
(8.14.0) IDE of the Coq formal proof management system</summary>
  <dl>
    <dt><b>authors</b></dt><dd>The Coq development team, INRIA, CNRS, and contributors.</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/LGPL-2.1-only.html" target="_blank">LGPL-2.1-only</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://coq.inria.fr/'>homepage</a>)
      (<a href='https://github.com/coq/coq/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/coqide/coqide.8.14.0/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>CoqIDE is a graphical user interface for interactive developmentnof mathematical definitions, executable algorithms, and proofs of theoremsnusing the Coq proof assistant.</dd>
  </dl>
</details>

<br>

## **Coq Platform 2021.09.0 with Coq 8.14.0 "full level"**

The **full level** adds many commonly used coq libraries, plug-ins and
developments.

The packages in the **full level** are mature, well maintained
and suitable as basis for your own developments.
See the Coq Platform [charter](charter.md) for deatils.

The **full level** contains the following packages:

<details>
  <summary><a href='https://github.com/coq-community/aac-tactics'>coq-aac-tactics.8.14.0</a>
(8.14.0) Coq plugin providing tactics for rewriting universally quantified equations, modulo associative (and possibly commutative) operators</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Thomas Braibant Damien Pous Fabian Kunze</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/LGPL-3.0-or-later.html" target="_blank">LGPL-3.0-or-later</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/coq-community/aac-tactics'>homepage</a>)
      (<a href='https://github.com/coq-community/aac-tactics/issues'>bug reports</a>)
      (<a href='https://coq.inria.fr/opam/released/packages/coq-aac-tactics/coq-aac-tactics.8.14.0/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>This Coq plugin provides tactics for rewriting universally quantifiednequations, modulo associativity and commutativity of some operator.nThe tactics can be applied for custom operators by registering thenoperators and their properties as type class instances. Many commonnoperator instances, such as for Z binary arithmetic and booleans, arenprovided with the plugin.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/coq/bignums'>coq-bignums.8.14.0</a>
(8.14.0) Bignums, the Coq library of arbitrary large numbers</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Laurent Théry - Benjamin Grégoire - Arnaud Spiwack - Evgeny Makarov - Pierre Letouzey</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/LGPL-2.1-only.html" target="_blank">LGPL-2.1-only</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/coq/bignums'>homepage</a>)
      (<a href='https://github.com/coq/bignums/issues'>bug reports</a>)
      (<a href='https://coq.inria.fr/opam/released/packages/coq-bignums/coq-bignums.8.14.0/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>Provides BigN, BigZ, BigQ that used to be part of Coq standard library &lt; 8.6</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/coq-community/coqeal'>coq-coqeal.1.0.6</a>
(1.0.6) CoqEAL - The Coq Effective Algebra Library</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Guillaume Cano - Cyril Cohen - Maxime Dénès - Anders Mörtberg - Damien Rouhling - Vincent Siles</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/MIT.html" target="_blank">MIT</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/coq-community/coqeal'>homepage</a>)
      (<a href='https://github.com/coq-community/coqeal/issues'>bug reports</a>)
      (<a href='https://coq.inria.fr/opam/released/packages/coq-coqeal/coq-coqeal.1.0.6/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>This Coq library contains a subset of the work that was developed in the contextnof the ForMath EU FP7 project (2009-2013). It has two parts:n- theory, which contains developments in algebra and optimized algorithms on mathcomp data structures.n- refinements, which is a framework to ease change of data representations during a proof.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/thery/coqprime'>coq-coqprime.1.1.0</a>
(1.1.0) Certifying prime numbers in Coq</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Laurent Théry</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/LGPL-2.1-only.html" target="_blank">LGPL-2.1-only</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/thery/coqprime'>homepage</a>)
      (<a href='https://github.com/thery/coqprime/issues'>bug reports</a>)
      (<a href='https://coq.inria.fr/opam/released/packages/coq-coqprime/coq-coqprime.1.1.0/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd></dd>
  </dl>
</details>

<details>
  <summary><a href='http://coquelicot.saclay.inria.fr/'>coq-coquelicot.3.2.0</a>
(3.2.0) A Coq formalization of real analysis compatible with the standard library</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Sylvie Boldo &lt;sylvie.boldo@inria.fr&gt; - Catherine Lelay &lt;catherine.lelay@inria.fr&gt; - Guillaume Melquiond &lt;guillaume.melquiond@inria.fr&gt;</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/LGPL-3.0-or-later.html" target="_blank">LGPL-3.0-or-later</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='http://coquelicot.saclay.inria.fr/'>homepage</a>)
      (<a href='https://gitlab.inria.fr/coquelicot/coquelicot/issues'>bug reports</a>)
      (<a href='https://coq.inria.fr/opam/released/packages/coq-coquelicot/coq-coquelicot.3.2.0/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd></dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/coq-community/corn'>coq-corn.8.13.0</a>
(8.13.0) The Coq Constructive Repository at Nijmegen</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Evgeny Makarov - Robbert Krebbers - Eelis van der Weegen - Bas Spitters - Jelle Herold - Russell O&apos;Connor - Cezary Kaliszyk - Dan Synek - Luís Cruz-Filipe - Milad Niqui - Iris Loeb - Herman Geuvers - Randy Pollack - Freek Wiedijk - Jan Zwanenburg - Dimitri Hendriks - Henk Barendregt - Mariusz Giero - Rik van Ginneken - Dimitri Hendriks - Sébastien Hinderer - Bart Kirkels - Pierre Letouzey - Lionel Mamane - Nickolay Shmyrev - Vincent Semeria</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/GPL-2.0-only.html" target="_blank">GPL-2.0-only</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/coq-community/corn'>homepage</a>)
      (<a href='https://github.com/coq-community/corn/issues'>bug reports</a>)
      (<a href='https://coq.inria.fr/opam/released/packages/coq-corn/coq-corn.8.13.0/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>CoRN includes the following parts:nn- Algebraic Hierarchynn  An axiomatic formalization of the most common algebraicn  structures, including setoids, monoids, groups, rings,n  fields, ordered fields, rings of polynomials, real andn  complex numbersnn- Model of the Real Numbersnn  Construction of a concrete real number structuren  satisfying the previously defined axiomsnn- Fundamental Theorem of Algebrann  A proof that every non-constant polynomial on the complexn  plane has at least one rootnn- Real Calculusnn  A collection of elementary results on real analysis,n  including continuity, differentiability, integration,n  Taylor&apos;s theorem and the Fundamental Theorem of Calculusnn- Exact Real Computationnn  Fast verified computation inside Coq. This includes: real numbers, functions,n  integrals, graphs of functions, differential equations.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/coq-community/coq-dpdgraph'>coq-dpdgraph.1.0+8.14</a>
(1.0+8.14) Compute dependencies between Coq objects (definitions, theorems) and produce graphs</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Anne Pacalet Yves Bertot Olivier Pons</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/LGPL-2.1-only.html" target="_blank">LGPL-2.1-only</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/coq-community/coq-dpdgraph'>homepage</a>)
      (<a href='https://github.com/coq-community/coq-dpdgraph/issues'>bug reports</a>)
      (<a href='https://coq.inria.fr/opam/released/packages/coq-dpdgraph/coq-dpdgraph.1.0+8.14/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>Coq plugin that extracts the dependencies between Coq objects,nand produces files with dependency information. Includes toolsnto visualize dependency graphs and find unused definitions.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/LPCIC/coq-elpi'>coq-elpi.1.11.2</a>
(1.11.2) Elpi extension language for Coq</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Enrico Tassi</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/LGPL-2.1-or-later.html" target="_blank">LGPL-2.1-or-later</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/LPCIC/coq-elpi'>homepage</a>)
      (<a href='https://github.com/LPCIC/coq-elpi/issues'>bug reports</a>)
      (<a href='https://coq.inria.fr/opam/released/packages/coq-elpi/coq-elpi.1.11.2/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>Coq-elpi provides a Coq plugin that embeds ELPI.nIt also provides a way to embed Coq&apos;s terms into λProlog usingnthe Higher-Order Abstract Syntax approachnand a way to read terms back.  In addition to that it exports to ELPI anset of Coq&apos;s primitives, e.g. printing a message, accessing thenenvironment of theorems and data types, defining a new constant and so on.nFor convenience it also provides a quotation and anti-quotation for Coq&apos;snsyntax in λProlog.  E.g. `{{nat}}` is expanded to the type name of naturalnnumbers, or `{{A -&gt; B}}` to the representation of a product by unfoldingn the `-&gt;` notation. Finally it provides a way to define new vernacular commandsnandnnew tactics.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://mattam82.github.io/Coq-Equations'>coq-equations.1.3+8.14</a>
(1.3+8.14) A function definition package for Coq</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Matthieu Sozeau &lt;matthieu.sozeau@inria.fr&gt; - Cyprien Mangin &lt;cyprien.mangin@m4x.org&gt;</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/LGPL-2.1-or-later.html" target="_blank">LGPL-2.1-or-later</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://mattam82.github.io/Coq-Equations'>homepage</a>)
      (<a href='https://github.com/mattam82/Coq-Equations/issues'>bug reports</a>)
      (<a href='https://coq.inria.fr/opam/released/packages/coq-equations/coq-equations.1.3+8.14/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>Equations is a function definition plugin for Coq, that allows thendefinition of functions by dependent pattern-matching and well-founded,nmutual or nested structural recursion and compiles them into corenterms. It automatically derives the clauses equations, the graph of thenfunction and its associated elimination principle.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/coq-community/coq-ext-lib'>coq-ext-lib.0.11.4</a>
(0.11.4) A library of Coq definitions, theorems, and tactics</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Gregory Malecha</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/BSD-2-Clause-FreeBSD.html" target="_blank">BSD-2-Clause-FreeBSD</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/coq-community/coq-ext-lib'>homepage</a>)
      (<a href='https://github.com/coq-community/coq-ext-lib/issues'>bug reports</a>)
      (<a href='https://coq.inria.fr/opam/released/packages/coq-ext-lib/coq-ext-lib.0.11.4/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>A collection of theories and plugins that may be useful in other Coq developments.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://flocq.gitlabpages.inria.fr/'>coq-flocq.3.4.2</a>
(3.4.2) A formalization of floating-point arithmetic for the Coq system</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Sylvie Boldo &lt;sylvie.boldo@inria.fr&gt; - Guillaume Melquiond &lt;guillaume.melquiond@inria.fr&gt;</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/LGPL-3.0-or-later.html" target="_blank">LGPL-3.0-or-later</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://flocq.gitlabpages.inria.fr/'>homepage</a>)
      (<a href='https://gitlab.inria.fr/flocq/flocq/issues'>bug reports</a>)
      (<a href='https://coq.inria.fr/opam/released/packages/coq-flocq/coq-flocq.3.4.2/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd></dd>
  </dl>
</details>

<details>
  <summary><a href='https://gappa.gitlabpages.inria.fr/'>coq-gappa.1.5.0</a>
(1.5.0) A Coq tactic for discharging goals about floating-point arithmetic and round-off errors using the Gappa prover</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Guillaume Melquiond &lt;guillaume.melquiond@inria.fr&gt;</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/LGPL-3.0-or-later.html" target="_blank">LGPL-3.0-or-later</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://gappa.gitlabpages.inria.fr/'>homepage</a>)
      (<a href='https://gitlab.inria.fr/gappa/coq/issues'>bug reports</a>)
      (<a href='https://coq.inria.fr/opam/released/packages/coq-gappa/coq-gappa.1.5.0/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd></dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/math-comp/hierarchy-builder'>coq-hierarchy-builder.1.2.0</a>
(1.2.0) High level commands to declare and evolve a hierarchy based on packed classes</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Cyril Cohen Kazuhiko Sakaguchi Enrico Tassi</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/MIT.html" target="_blank">MIT</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/math-comp/hierarchy-builder'>homepage</a>)
      (<a href='https://github.com/math-comp/hierarchy-builder/issues'>bug reports</a>)
      (<a href='https://coq.inria.fr/opam/released/packages/coq-hierarchy-builder/coq-hierarchy-builder.1.2.0/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>Hierarchy Builder is a high level language to build hierarchies of algebraic structures and make thesenhierarchies evolve without breaking user code. The key concepts are the ones of factory, buildernand abbreviation that let the hierarchy developer describe an actual interface for their library.nBehind that interface the developer can provide appropriate code to ensure retro compatibility.</dd>
  </dl>
</details>

<details>
  <summary><a href='http://homotopytypetheory.org/'>coq-hott.8.13</a>
(8.13) The Homotopy Type Theory library</summary>
  <dl>
    <dt><b>authors</b></dt><dd>The Coq-HoTT Development Team</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/BSD-2-Clause.html" target="_blank">BSD-2-Clause</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='http://homotopytypetheory.org/'>homepage</a>)
      (<a href='https://github.com/HoTT/HoTT/issues'>bug reports</a>)
      (<a href='https://github.com/coq/platform/tree/main/opam/opam-coq-archive/released/packages/coq-hott/coq-hott.8.13/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>To use the HoTT library, the following flags must be passed to coqc:n   -noinit -indices-matternTo use the HoTT library in a project, add the following to _CoqProject:n   -arg -noinitn   -arg -indices-matter</dd>
  </dl>
</details>

<details>
  <summary><a href='https://coqinterval.gitlabpages.inria.fr/'>coq-interval.4.3.0</a>
(4.3.0) A Coq tactic for proving bounds on real-valued expressions automatically</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Guillaume Melquiond &lt;guillaume.melquiond@inria.fr&gt; - Érik Martin-Dorel &lt;erik.martin-dorel@irit.fr&gt; - Pierre Roux &lt;pierre.roux@onera.fr&gt; - Thomas Sibut-Pinote &lt;thomas.sibut-pinote@inria.fr&gt;</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/CECILL-C.html" target="_blank">CECILL-C</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://coqinterval.gitlabpages.inria.fr/'>homepage</a>)
      (<a href='https://gitlab.inria.fr/coqinterval/interval/issues'>bug reports</a>)
      (<a href='https://coq.inria.fr/opam/released/packages/coq-interval/coq-interval.4.3.0/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd></dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/coq-community/math-classes'>coq-math-classes.8.13.0</a>
(8.13.0) A library of abstract interfaces for mathematical structures in Coq</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Eelis van der Weegen Bas Spitters Robbert Krebbers</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/MIT.html" target="_blank">MIT</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/coq-community/math-classes'>homepage</a>)
      (<a href='https://github.com/coq-community/math-classes/issues'>bug reports</a>)
      (<a href='https://github.com/coq/platform/tree/main/opam/opam-coq-archive/released/packages/coq-math-classes/coq-math-classes.8.13.0/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>Math classes is a library of abstract interfaces for mathematicalnstructures, such as:nn*  Algebraic hierarchy (groups, rings, fields, …)n*  Relations, orders, …n*  Categories, functors, universal algebra, …n*  Numbers: N, Z, Q, …n*  Operations, (shift, power, abs, …)nnIt is heavily based on Coq’s new type classes in order to provide:nstructure inference, multiple inheritance/sharing, convenientnalgebraic manipulation (e.g. rewriting) and idiomatic use ofnnotations.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://math-comp.github.io/'>coq-mathcomp-algebra.1.12.0</a>
(1.12.0) Mathematical Components Library on Algebra</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Jeremy Avigad  - Andrea Asperti  - Stephane Le Roux  - Yves Bertot  - Laurence Rideau  - Enrico Tassi  - Ioana Pasca  - Georges Gonthier  - Sidi Ould Biha  - Cyril Cohen  - Francois Garillot  - Alexey Solovyev  - Russell O&apos;Connor  - Laurent Théry  - Assia Mahboubi </dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/CECILL-B.html" target="_blank">CECILL-B</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://math-comp.github.io/'>homepage</a>)
      (<a href='https://github.com/math-comp/math-comp/issues'>bug reports</a>)
      (<a href='https://coq.inria.fr/opam/released/packages/coq-mathcomp-algebra/coq-mathcomp-algebra.1.12.0/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>This library contains definitions and theorems about discreten(i.e. with decidable equality) algebraic structures : ring, fields,nordered fields, real fields,  modules, algebras, integers, rationalnnumbers, polynomials, matrices, vector spaces...</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/math-comp/analysis'>coq-mathcomp-analysis.0.3.10</a>
(0.3.10) An analysis library for mathematical components</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Reynald Affeldt - Cyril Cohen - Marie Kerjean - Assia Mahboubi - Damien Rouhling - Pierre Roux - Kazuhiko Sakaguchi - Pierre-Yves Strub - Laurent Théry</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/CECILL-C.html" target="_blank">CECILL-C</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/math-comp/analysis'>homepage</a>)
      (<a href='https://github.com/math-comp/analysis/issues'>bug reports</a>)
      (<a href='https://github.com/coq/platform/tree/main/opam/opam-coq-archive/released/packages/coq-mathcomp-analysis/coq-mathcomp-analysis.0.3.10/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>This repository contains an experimental library for real analysis fornthe Coq proof-assistant and using the Mathematical Components library.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/math-comp/bigenough'>coq-mathcomp-bigenough.1.0.0</a>
(1.0.0) A small library to do epsilon - N reasonning</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Cyril Cohen &lt;cyril.cohen@inria.fr&gt;</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/CECILL-B.html" target="_blank">CECILL-B</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/math-comp/bigenough'>homepage</a>)
      (<a href='https://github.com/math-comp/bigenough/issues'>bug reports</a>)
      (<a href='https://coq.inria.fr/opam/released/packages/coq-mathcomp-bigenough/coq-mathcomp-bigenough.1.0.0/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>The package contains a package to reasoning with big enough objectsn(mostly natural numbers). This package is essentially for backwardncompatibility purposes as `bigenough` will be subsumed by the nearntactics. The formalization is based on the Mathematical Componentsnlibrary.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://math-comp.github.io/'>coq-mathcomp-character.1.12.0</a>
(1.12.0) Mathematical Components Library on character theory</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Jeremy Avigad  - Andrea Asperti  - Stephane Le Roux  - Yves Bertot  - Laurence Rideau  - Enrico Tassi  - Ioana Pasca  - Georges Gonthier  - Sidi Ould Biha  - Cyril Cohen  - Francois Garillot  - Alexey Solovyev  - Russell O&apos;Connor  - Laurent Théry  - Assia Mahboubi </dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/CECILL-B.html" target="_blank">CECILL-B</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://math-comp.github.io/'>homepage</a>)
      (<a href='https://github.com/math-comp/math-comp/issues'>bug reports</a>)
      (<a href='https://coq.inria.fr/opam/released/packages/coq-mathcomp-character/coq-mathcomp-character.1.12.0/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>This library contains definitions and theorems about groupnrepresentations, characters and class functions.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://math-comp.github.io/'>coq-mathcomp-field.1.12.0</a>
(1.12.0) Mathematical Components Library on Fields</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Jeremy Avigad  - Andrea Asperti  - Stephane Le Roux  - Yves Bertot  - Laurence Rideau  - Enrico Tassi  - Ioana Pasca  - Georges Gonthier  - Sidi Ould Biha  - Cyril Cohen  - Francois Garillot  - Alexey Solovyev  - Russell O&apos;Connor  - Laurent Théry  - Assia Mahboubi </dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/CECILL-B.html" target="_blank">CECILL-B</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://math-comp.github.io/'>homepage</a>)
      (<a href='https://github.com/math-comp/math-comp/issues'>bug reports</a>)
      (<a href='https://coq.inria.fr/opam/released/packages/coq-mathcomp-field/coq-mathcomp-field.1.12.0/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>This library contains definitions and theorems about field extensions,ngalois theory, algebraic numbers, cyclotomic polynomials...</dd>
  </dl>
</details>

<details>
  <summary><a href='https://math-comp.github.io/'>coq-mathcomp-fingroup.1.12.0</a>
(1.12.0) Mathematical Components Library on finite groups</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Jeremy Avigad  - Andrea Asperti  - Stephane Le Roux  - Yves Bertot  - Laurence Rideau  - Enrico Tassi  - Ioana Pasca  - Georges Gonthier  - Sidi Ould Biha  - Cyril Cohen  - Francois Garillot  - Alexey Solovyev  - Russell O&apos;Connor  - Laurent Théry  - Assia Mahboubi </dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/CECILL-B.html" target="_blank">CECILL-B</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://math-comp.github.io/'>homepage</a>)
      (<a href='https://github.com/math-comp/math-comp/issues'>bug reports</a>)
      (<a href='https://coq.inria.fr/opam/released/packages/coq-mathcomp-fingroup/coq-mathcomp-fingroup.1.12.0/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>This library contains definitions and theorems about finite groups,ngroup quotients, group morphisms, group presentation, group action...</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/math-comp/finmap'>coq-mathcomp-finmap.1.5.1</a>
(1.5.1) Finite sets, finite maps, finitely supported functions</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Cyril Cohen Kazuhiko Sakaguchi</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/CECILL-B.html" target="_blank">CECILL-B</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/math-comp/finmap'>homepage</a>)
      (<a href='https://github.com/math-comp/finmap/issues'>bug reports</a>)
      (<a href='https://coq.inria.fr/opam/released/packages/coq-mathcomp-finmap/coq-mathcomp-finmap.1.5.1/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>This library is an extension of mathematical component in order tonsupport finite sets and finite maps on choicetypes (rather that finitentypes). This includes support for functions with finite support andnmultisets. The library also contains a generic order and set libary,nwhich will be used to subsume notations for finite sets, eventually.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/math-comp/multinomials'>coq-mathcomp-multinomials.1.5.4</a>
(1.5.4) A Multivariate polynomial Library for the Mathematical Components Library</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Pierre-Yves Strub</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/CECILL-B.html" target="_blank">CECILL-B</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/math-comp/multinomials'>homepage</a>)
      (<a href='https://github.com/math-comp/multinomials/issues'>bug reports</a>)
      (<a href='https://coq.inria.fr/opam/released/packages/coq-mathcomp-multinomials/coq-mathcomp-multinomials.1.5.4/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd></dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/math-comp/real-closed'>coq-mathcomp-real-closed.1.1.2</a>
(1.1.2) Mathematical Components Library on real closed fields</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Cyril Cohen Assia Mahboubi</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/CECILL-B.html" target="_blank">CECILL-B</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/math-comp/real-closed'>homepage</a>)
      (<a href='https://github.com/math-comp/real-closed/issues'>bug reports</a>)
      (<a href='https://coq.inria.fr/opam/released/packages/coq-mathcomp-real-closed/coq-mathcomp-real-closed.1.1.2/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>This library contains definitions and theorems about real closednfields, with a construction of the real closure and the algebraicnclosure (including a proof of the fundamental theorem ofnalgebra). It also contains a proof of decidability of the firstnorder theory of real closed field, through quantifier elimination.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://math-comp.github.io/'>coq-mathcomp-solvable.1.12.0</a>
(1.12.0) Mathematical Components Library on finite groups (II)</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Jeremy Avigad  - Andrea Asperti  - Stephane Le Roux  - Yves Bertot  - Laurence Rideau  - Enrico Tassi  - Ioana Pasca  - Georges Gonthier  - Sidi Ould Biha  - Cyril Cohen  - Francois Garillot  - Alexey Solovyev  - Russell O&apos;Connor  - Laurent Théry  - Assia Mahboubi </dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/CECILL-B.html" target="_blank">CECILL-B</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://math-comp.github.io/'>homepage</a>)
      (<a href='https://github.com/math-comp/math-comp/issues'>bug reports</a>)
      (<a href='https://coq.inria.fr/opam/released/packages/coq-mathcomp-solvable/coq-mathcomp-solvable.1.12.0/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>This library contains more definitions and theorems about finite groups.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://math-comp.github.io/'>coq-mathcomp-ssreflect.1.12.0</a>
(1.12.0) Small Scale Reflection</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Jeremy Avigad  - Andrea Asperti  - Stephane Le Roux  - Yves Bertot  - Laurence Rideau  - Enrico Tassi  - Ioana Pasca  - Georges Gonthier  - Sidi Ould Biha  - Cyril Cohen  - Francois Garillot  - Alexey Solovyev  - Russell O&apos;Connor  - Laurent Théry  - Assia Mahboubi </dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/CECILL-B.html" target="_blank">CECILL-B</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://math-comp.github.io/'>homepage</a>)
      (<a href='https://github.com/math-comp/math-comp/issues'>bug reports</a>)
      (<a href='https://coq.inria.fr/opam/released/packages/coq-mathcomp-ssreflect/coq-mathcomp-ssreflect.1.12.0/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>This library includes the small scale reflection proof languagenextension and the minimal set of libraries to take advantage of it.nThis includes libraries on lists (seq), boolean and booleannpredicates, natural numbers and types with decidable equality,nfinite types, finite sets, finite functions, finite graphs, basic arithmeticsnand prime numbers, big operators</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/math-comp/mczify'>coq-mathcomp-zify.1.1.0+1.12+8.13</a>
(1.1.0+1.12+8.13) Micromega tactics for Mathematical Components</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Kazuhiko Sakaguchi</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/CECILL-B.html" target="_blank">CECILL-B</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/math-comp/mczify'>homepage</a>)
      (<a href='https://github.com/math-comp/mczify/issues'>bug reports</a>)
      (<a href='https://coq.inria.fr/opam/released/packages/coq-mathcomp-zify/coq-mathcomp-zify.1.1.0+1.12+8.13/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>This small library enables the use of the Micromega arithmetic solvers of Coqnfor goals stated with the definitions of the Mathematical Components librarynby extending the zify tactic.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://gitlab.inria.fr/fpottier/coq-menhirlib'>coq-menhirlib.20210419</a>
(20210419) A support library for verified Coq parsers produced by Menhir</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Jacques-Henri Jourdan &lt;jacques-henri.jourdan@lri.fr&gt;</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/LGPL-3.0-or-later.html" target="_blank">LGPL-3.0-or-later</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://gitlab.inria.fr/fpottier/coq-menhirlib'>homepage</a>)
      (<a href='https://gitlab.inria.fr/fpottier/menhir/-/issues'>bug reports</a>)
      (<a href='https://coq.inria.fr/opam/released/packages/coq-menhirlib/coq-menhirlib.20210419/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd></dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/Mtac2/Mtac2'>coq-mtac2.1.4+8.14</a>
(1.4+8.14) Mtac2: Typed Tactics for Coq</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Beta Ziliani &lt;beta.ziliani@gmail.com&gt; - Jan-Oliver Kaiser &lt;janno@mpi-sws.org&gt; - Robbert Krebbers &lt;mail@robbertkrebbers.nl&gt; - Yann Régis-Gianas &lt;yrg@pps.univ-paris-diderot.fr&gt; - Derek Dreyer &lt;dreyer@mpi-sws.org&gt;</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/MIT.html" target="_blank">MIT</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/Mtac2/Mtac2'>homepage</a>)
      (<a href='https://github.com/Mtac2/Mtac2/issues'>bug reports</a>)
      (<a href='https://github.com/coq/platform/tree/main/opam/opam-coq-archive/released/packages/coq-mtac2/coq-mtac2.1.4+8.14/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd></dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/coq-community/paramcoq'>coq-paramcoq.1.1.3+coq8.14</a>
(1.1.3+coq8.14) Plugin for generating parametricity statements to perform refinement proofs</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Chantal Keller (Inria, École polytechnique) - Marc Lasson (ÉNS de Lyon) - Abhishek Anand - Pierre Roux - Emilio Jesús Gallego Arias - Cyril Cohen - Matthieu Sozeau</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/MIT.html" target="_blank">MIT</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/coq-community/paramcoq'>homepage</a>)
      (<a href='https://github.com/coq-community/paramcoq/issues'>bug reports</a>)
      (<a href='https://coq.inria.fr/opam/released/packages/coq-paramcoq/coq-paramcoq.1.1.3+coq8.14/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>A Coq plugin providing commands for generating parametricity statements.nTypical applications of such statements are in data refinement proofs.nNote that the plugin is still in an experimental state - it is not very usernfriendly (lack of good error messages) and still contains bugs. But itnis usable enough to translate a large chunk of the standard library.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/QuickChick/QuickChick'>coq-quickchick.1.5.1</a>
(1.5.1) Randomized Property-Based Testing Plugin for Coq</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Leonidas Lampropoulos  - Zoe Paraskevopoulou  - Maxime Denes  - Catalin Hritcu  - Benjamin Pierce  - Li-yao Xia  - Arthur Azevedo de Amorim  - Yishuai Li  - Antal Spector-Zabusky </dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/MIT.html" target="_blank">MIT</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/QuickChick/QuickChick'>homepage</a>)
      (<a href='https://github.com/QuickChick/QuickChick/issues'>bug reports</a>)
      (<a href='https://coq.inria.fr/opam/released/packages/coq-quickchick/coq-quickchick.1.5.1/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd></dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/coq-community/reglang'>coq-reglang.1.1.2</a>
(1.1.2) Representations of regular languages (i.e., regexps, various types of automata, and WS1S) with equivalence proofs, in Coq and MathComp</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Christian Doczkal Jan-Oliver Kaiser Gert Smolka</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/CECILL-B.html" target="_blank">CECILL-B</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/coq-community/reglang'>homepage</a>)
      (<a href='https://github.com/coq-community/reglang/issues'>bug reports</a>)
      (<a href='https://coq.inria.fr/opam/released/packages/coq-reglang/coq-reglang.1.1.2/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>This library provides definitions and verified translations betweenndifferent representations of regular languages: various forms ofnautomata (deterministic, nondeterministic, one-way, two-way),nregular expressions, and the logic WS1S. It also contains variousndecidability results and closure properties of regular languages.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/Lysxia/coq-simple-io'>coq-simple-io.1.6.0</a>
(1.6.0) IO monad for Coq</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Li-yao Xia Yishuai Li</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/MIT.html" target="_blank">MIT</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/Lysxia/coq-simple-io'>homepage</a>)
      (<a href='https://github.com/Lysxia/coq-simple-io/issues'>bug reports</a>)
      (<a href='https://coq.inria.fr/opam/released/packages/coq-simple-io/coq-simple-io.1.6.0/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>This library provides tools to implement IO programs directly in Coq, in ansimilar style to Haskell. Facilities for formal verification are not included.nnIO is defined as a parameter with a purely functional interface in Coq,nto be extracted to OCaml. Some wrappers for the basic types and functions innthe OCaml Pervasives module are provided. Users are free to define their ownnAPIs on top of this IO type.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/unicoq/unicoq'>coq-unicoq.1.5+8.14</a>
(1.5+8.14) An enhanced unification algorithm for Coq</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Matthieu Sozeau &lt;matthieu.sozeau@inria.fr&gt; - Beta Ziliani &lt;beta@mpi-sws.org&gt;</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/MIT.html" target="_blank">MIT</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/unicoq/unicoq'>homepage</a>)
      (<a href='https://github.com/unicoq/unicoq/issues'>bug reports</a>)
      (<a href='https://github.com/coq/platform/tree/main/opam/opam-coq-archive/released/packages/coq-unicoq/coq-unicoq.1.5+8.14/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd></dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/UniMath/UniMath'>coq-unimath.20210807</a>
(20210807) Library of Univalent Mathematics</summary>
  <dl>
    <dt><b>authors</b></dt><dd>The UniMath Development Team</dd>
    <dt><b>license</b></dt><dd> Kind of MIT - see <a href="https://github.com/UniMath/UniMath" target="_blank">homepage</a> for details</dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/UniMath/UniMath'>homepage</a>)
      (<a href='https://github.com/UniMath/UniMath/issues'>bug reports</a>)
      (<a href='https://coq.inria.fr/opam/released/packages/coq-unimath/coq-unimath.20210807/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd></dd>
  </dl>
</details>

<details>
  <summary><a href='https://gitlab.inria.fr/gappa/gappa'>gappa.1.4.0</a>
(1.4.0) Tool intended for formally proving properties on numerical programs dealing with floating-point or fixed-point arithmetic</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Guillaume Melquiond</dd>
    <dt><b>license</b></dt><dd> CECILL - see <a href="https://gitlab.inria.fr/gappa/gappa" target="_blank">homepage</a> for details</dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://gitlab.inria.fr/gappa/gappa'>homepage</a>)
      (<a href='https://gitlab.inria.fr/gappa/gappa/-/issues'>bug reports</a>)
      (<a href='https://github.com/coq/platform/tree/main/opam/opam-repository/packages/gappa/gappa.1.4.0/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd></dd>
  </dl>
</details>

<details>
  <summary><a href='http://gitlab.inria.fr/fpottier/menhir'>menhir.20210419</a>
(20210419) An LR(1) parser generator</summary>
  <dl>
    <dt><b>authors</b></dt><dd>François Pottier &lt;francois.pottier@inria.fr&gt; - Yann Régis-Gianas &lt;yrg@pps.univ-paris-diderot.fr&gt;</dd>
    <dt><b>license</b></dt><dd> LGPL-2.0-only WITH OCaml-LGPL-linking-exception - see <a href="http://gitlab.inria.fr/fpottier/menhir" target="_blank">homepage</a> for details</dd>
    <dt><b>links</b></dt><dd>
      (<a href='http://gitlab.inria.fr/fpottier/menhir'>homepage</a>)
      (<a href='https://gitlab.inria.fr/fpottier/menhir/-/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/menhir/menhir.20210419/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd></dd>
  </dl>
</details>

<br>

## **Coq Platform 2021.09.0 with Coq 8.14.0 "optional packages"**

The **optional** packages have the same maturity and maintenance level as the
packages in the full level, but either have a **non open source license** or
depend on packages with non open source license.

The interactive installation script and the Windows installer explicitly ask
if you want to install these packages.

The macOS and snap installation bundles always include these packages.

The following packages are **optional**:

<details>
  <summary><a href='http://compcert.inria.fr/'>coq-compcert.3.9</a>
(3.9) The CompCert C compiler (64 bit)</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Xavier Leroy &lt;xavier.leroy@inria.fr&gt;</dd>
    <dt><b>license</b></dt><dd> INRIA Non-Commercial License Agreement - see <a href="http://compcert.inria.fr/" target="_blank">homepage</a> for details</dd>
    <dt><b>links</b></dt><dd>
      (<a href='http://compcert.inria.fr/'>homepage</a>)
      (<a href='https://github.com/AbsInt/CompCert/issues'>bug reports</a>)
      (<a href='https://github.com/coq/platform/tree/main/opam/opam-coq-archive/released/packages/coq-compcert/coq-compcert.3.9/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd></dd>
  </dl>
</details>

<details>
  <summary><a href='http://vst.cs.princeton.edu/'>coq-vst.2.8</a>
(2.8) Verified Software Toolchain</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Andrew W. Appel - Lennart Beringer - Sandrine Blazy - Qinxiang Cao - Santiago Cuellar - Robert Dockins - Josiah Dodds - Nick Giannarakis - Samuel Gruetter - Aquinas Hobor - Jean-Marie Madiot - William Mansky</dd>
    <dt><b>license</b></dt><dd> <a href="https://raw.githubusercontent.com/PrincetonUniversity/VST/master/LICENSE" target="_blank">link</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='http://vst.cs.princeton.edu/'>homepage</a>)
      (<a href='https://github.com/PrincetonUniversity/VST/issues'>bug reports</a>)
      (<a href='https://github.com/coq/platform/tree/main/opam/opam-coq-archive/released/packages/coq-vst/coq-vst.2.8/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>The software toolchain includes static analyzers to check assertions about your program; optimizing compilers to translate your program to machine language; operating systems and libraries to supply context for your program. The Verified Software Toolchain project assures with machine-checked proofs that the assertions claimed at the top of the toolchain really hold in the machine-language program, running in the operating-system context.</dd>
  </dl>
</details>

<br>

## **Coq Platform 2021.09.0 with Coq 8.14.0 "extended level"**

The **extended level** contains packages which are in a beta stage or otherwise
don't yet have the level of maturity or support required for inclusion in the
full level, but there are plans to move them to the full level in a future
release of Coq Platform. The main point of the extended level is advertisement:
users are important to bring a development from a beta to a release state.

The interactive installation script explicitly asks if you want to install these packages.
The macOS and snap installation bundles always include these packages.
The Windows installer also includes them, and they are selected by default.

The **extended level** contains the following packages:

<details>
  <summary><a href='https://github.com/arthuraa/deriving'>coq-deriving.0.1.0</a>
(0.1.0) Generic instances of MathComp classes</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Arthur Azevedo de Amorim</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/MIT.html" target="_blank">MIT</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/arthuraa/deriving'>homepage</a>)
      (<a href='https://github.com/arthuraa/deriving/issues'>bug reports</a>)
      (<a href='https://github.com/coq/platform/tree/main/opam/opam-coq-archive/released/packages/coq-deriving/coq-deriving.0.1.0/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>Deriving provides generic instances of MathComp classes forninductive data types.  It includes native support for eqType,nchoiceType, countType and finType instances, and it allows users tondefine their own instances for other classes.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/tchajed/coq-record-update'>coq-record-update.0.3.0</a>
(0.3.0) Generic support for updating record fields in Coq</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Tej Chajed</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/MIT.html" target="_blank">MIT</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/tchajed/coq-record-update'>homepage</a>)
      (<a href='https://github.com/tchajed/coq-record-update/issues'>bug reports</a>)
      (<a href='https://coq.inria.fr/opam/released/packages/coq-record-update/coq-record-update.0.3.0/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>While Coq provides projections for each field of a record, it has nonconvenient way to update a single field of a record. This library provides angeneric way to update a field by name, where the user only has to implement ansimple typeclass that lists out the record fields.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/coq-community/reduction-effects'>coq-reduction-effects.0.1.3</a>
(0.1.3) A Coq plugin to add reduction side effects to some Coq reduction strategies</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Hugo Herbelin</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/MPL-2.0.html" target="_blank">MPL-2.0</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/coq-community/reduction-effects'>homepage</a>)
      (<a href='https://github.com/coq-community/reduction-effects/issues'>bug reports</a>)
      (<a href='https://coq.inria.fr/opam/released/packages/coq-reduction-effects/coq-reduction-effects.0.1.3/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd></dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/ejgallego/coq-serapi'>coq-serapi.8.14.0+0.14.0</a>
(8.14.0+0.14.0) Serialization library and protocol for machine interaction with the Coq proof assistant</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Emilio Jesús Gallego Arias - Karl Palmskog - Clément Pit-Claudel - Kaiyu Yang</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/GPL-3.0-or-later.html" target="_blank">GPL-3.0-or-later</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/ejgallego/coq-serapi'>homepage</a>)
      (<a href='https://github.com/ejgallego/coq-serapi/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/coq-serapi/coq-serapi.8.14.0+0.14.0/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>SerAPI is a library for machine-to-machine interaction with thenCoq proof assistant, with particular emphasis on applications in IDEs,ncode analysis tools, and machine learning. SerAPI provides automaticnserialization of Coq&apos;s internal OCaml datatypes from/to JSON ornS-expressions (sexps).</dd>
  </dl>
</details>

<br>

## **Dependecy packages**

In addition the dependencies listed below are partially or fully included or required during build time.
Please note, that the version numbers given are the versions of opam packages,
which do not always match with the version of the supplied packages.
E.g. some opam packages just refer to latest packages e.g. installed by MacPorts,
Homebrew or Linux system package managers.
Please refer to the linked opam package and/or your system package manager for details on what software version is used.

<details>
  <summary><a href=''>base-bigarray.base</a>
(base) </summary>
  <dl>
    <dt><b>authors</b></dt><dd></dd>
    <dt><b>license</b></dt><dd>unknown - please clarify with <a href="" target="_blank">homepage</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://opam.ocaml.org/packages/base-bigarray/base-bigarray.base/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>Bigarray library distributed with the OCaml compiler</dd>
  </dl>
</details>

<details>
  <summary><a href=''>base-threads.base</a>
(base) </summary>
  <dl>
    <dt><b>authors</b></dt><dd></dd>
    <dt><b>license</b></dt><dd>unknown - please clarify with <a href="" target="_blank">homepage</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://opam.ocaml.org/packages/base-threads/base-threads.base/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>Threads library distributed with the OCaml compiler</dd>
  </dl>
</details>

<details>
  <summary><a href=''>base-unix.base</a>
(base) </summary>
  <dl>
    <dt><b>authors</b></dt><dd></dd>
    <dt><b>license</b></dt><dd>unknown - please clarify with <a href="" target="_blank">homepage</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://opam.ocaml.org/packages/base-unix/base-unix.base/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>Unix library distributed with the OCaml compiler</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/janestreet/base'>base.v0.14.1</a>
(v0.14.1) Full standard library replacement for OCaml</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Jane Street Group, LLC</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/MIT.html" target="_blank">MIT</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/janestreet/base'>homepage</a>)
      (<a href='https://github.com/janestreet/base/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/base/base.v0.14.1/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>Full standard library replacement for OCamlnnBase is a complete and portable alternative to the OCaml standardnlibrary. It provides all standard functionalities one would expectnfrom a language standard library. It uses consistent conventionsnacross all of its module.nnBase aims to be usable in any context. As a result system dependentnfeatures such as I/O are not offered by Base. They are insteadnprovided by companion libraries such as stdio:nn  https://github.com/janestreet/stdio</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/mjambon/biniou'>biniou.1.2.1</a>
(1.2.1) Binary data format designed for speed, safety, ease of use and backward compatibility as protocols evolve</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Martin Jambon</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/BSD-3-Clause.html" target="_blank">BSD-3-Clause</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/mjambon/biniou'>homepage</a>)
      (<a href='https://github.com/mjambon/biniou/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/biniou/biniou.1.2.1/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>Biniou (pronounced be new) is a binary data format designed for speed, safety,nease of use and backward compatibility as protocols evolve. Biniou is vastlynequivalent to JSON in terms of functionality but allows implementations severalntimes faster (4 times faster than yojson), with 25-35% space savings.nnBiniou data can be decoded into human-readable form without knowledge of typendefinitions except for field and variant names which are represented by 31-bitnhashes. A program named bdump is provided for routine visualization of binioundata files.nnThe program atdgen is used to derive OCaml-Biniou serializers and deserializersnfrom type definitions.nnBiniou format specification: mjambon.github.io/atdgen-doc/biniou-format.txt</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/Chris00/ocaml-cairo'>cairo2.0.6.2</a>
(0.6.2) Binding to Cairo, a 2D Vector Graphics Library</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Christophe Troestler &lt;Christophe.Troestler@umons.ac.be&gt; - Pierre Hauweele &lt;pierre@hauweele.net&gt;</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/LGPL-3.0-only.html" target="_blank">LGPL-3.0-only</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/Chris00/ocaml-cairo'>homepage</a>)
      (<a href='https://github.com/Chris00/ocaml-cairo/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/cairo2/cairo2.0.6.2/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>This is a binding to Cairo, a 2D graphics library with support fornmultiple output devices. Currently supported output targets includenthe X Window System, Quartz, Win32, image buffers, PostScript, PDF,nand SVG file output.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://camlp5.github.io'>camlp5.7.14</a>
(7.14) Preprocessor-pretty-printer of OCaml</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Daniel de Rauglaudre</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/BSD-3-Clause.html" target="_blank">BSD-3-Clause</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://camlp5.github.io'>homepage</a>)
      (<a href='https://github.com/camlp5/camlp5/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/camlp5/camlp5.7.14/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>Camlp5 is a preprocessor and pretty-printer for OCaml programs. It also provides parsing and printing tools.nnAs a preprocessor, it allows to:nnextend the syntax of OCaml,nredefine the whole syntax of the language.nAs a pretty printer, it allows to:nndisplay OCaml programs in an elegant way,nconvert from one syntax to another,ncheck the results of syntax extensions.nCamlp5 also provides some parsing and pretty printing tools:nnextensible grammarsnextensible printersnstream parsers and lexersnpretty print modulenIt works as a shell command and can also be used in the OCaml toplevel.</dd>
  </dl>
</details>

<details>
  <summary><a href='http://erratique.ch/software/cmdliner'>cmdliner.1.0.4</a>
(1.0.4) Declarative definition of command line interfaces for OCaml</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Daniel Bünzli &lt;daniel.buenzl i@erratique.ch&gt;</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/ISC.html" target="_blank">ISC</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='http://erratique.ch/software/cmdliner'>homepage</a>)
      (<a href='https://github.com/dbuenzli/cmdliner/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/cmdliner/cmdliner.1.0.4/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>Cmdliner allows the declarative definition of command line interfacesnfor OCaml.nnIt provides a simple and compositional mechanism to convert commandnline arguments to OCaml values and pass them to your functions. Thenmodule automatically handles syntax errors, help messages and UNIX mannpage generation. It supports programs with single or multiple commandsnand respects most of the [POSIX][1] and [GNU][2] conventions.nnCmdliner has no dependencies and is distributed under the ISC license.nn[1]: http://pubs.opengroup.org/onlinepubs/009695399/basedefs/xbd_chap12.htmln[2]: http://www.gnu.org/software/libc/manual/html_node/Argument-Syntax.html</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/GNOME/adwaita-icon-theme'>adwaita-icon-theme.1</a>
(1) Virtual package relying on adwaita-icon-theme</summary>
  <dl>
    <dt><b>authors</b></dt><dd>GNOME devs</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/LGPL-3.0-only.html" target="_blank">LGPL-3.0-only</a> <a href="https://spdx.org/licenses/CC-BY-SA-3.0.html" target="_blank">CC-BY-SA-3.0</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/GNOME/adwaita-icon-theme'>homepage</a>)
      (<a href='https://gitlab.gnome.org/GNOME/adwaita-icon-theme/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/conf-adwaita-icon-theme/conf-adwaita-icon-theme.1/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>This package can only install if the adwaita-icon-theme package is installed on the system.</dd>
  </dl>
</details>

<details>
  <summary><a href='http://www.gnu.org/software/autoconf'>autoconf.0.1</a>
(0.1) Virtual package relying on autoconf installation</summary>
  <dl>
    <dt><b>authors</b></dt><dd>https://www.gnu.org/software/autoconf/autoconf.html#maintainer</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/GPL-3.0-only.html" target="_blank">GPL-3.0-only</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='http://www.gnu.org/software/autoconf'>homepage</a>)
      (<a href='https://github.com/ocaml/opam-repository/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/conf-autoconf/conf-autoconf.0.1/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>This package can only install if the autoconf commandnis available on the system.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://www.gnu.org/software/automake'>automake.1</a>
(1) Virtual package relying on GNU automake</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Jim Meyering - David J. MacKenzie - https://git.savannah.gnu.org/cgit/automake.git/tree/THANKS </dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/GPL-2.0-or-later.html" target="_blank">GPL-2.0-or-later</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://www.gnu.org/software/automake'>homepage</a>)
      (<a href='https://www.gnu.org/software/automake/manual/html_node/Reporting-Bugs.html'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/conf-automake/conf-automake.1/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>This package can only install if GNU automake is installed on the system.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://www.gnu.org/software/bison/'>bison.2</a>
(2) Virtual package relying on GNU bison</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Robert Corbett - Richard Stallman - Wilfred Hansen - Akim Demaille - Paul Hilfinger - Joel E. Denny - Paolo Bonzini - Alex Rozenman - Paul Eggert</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/GPL-3.0-or-later.html" target="_blank">GPL-3.0-or-later</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://www.gnu.org/software/bison/'>homepage</a>)
      (<a href='https://lists.gnu.org/mailman/listinfo/bug-bison'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/conf-bison/conf-bison.2/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>This package can only install if GNU bison is installed on the system.</dd>
  </dl>
</details>

<details>
  <summary><a href='http://www.boost.org'>boost.1</a>
(1) Virtual package relying on boost</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Beman Dawes, David Abrahams, et al.</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/MIT.html" target="_blank">MIT</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='http://www.boost.org'>homepage</a>)
      (<a href='https://github.com/ocaml/opam-repository/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/conf-boost/conf-boost.1/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>This package can only install if the boost library is installed on the system.</dd>
  </dl>
</details>

<details>
  <summary><a href='http://cairographics.org/'>cairo.1</a>
(1) Virtual package relying on a Cairo system installation</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Keith Packard Carl Worth Behdad Esfahbod</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/LGPL-2.1-only.html" target="_blank">LGPL-2.1-only</a> <a href="https://spdx.org/licenses/MPL-1.1.html" target="_blank">MPL-1.1</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='http://cairographics.org/'>homepage</a>)
      (<a href='https://github.com/ocaml/opam-repository/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/conf-cairo/conf-cairo.1/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>This package can only install if the cairo lib is installed on the system.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://www.gnu.org/software/findutils/'>findutils.1</a>
(1) Virtual package relying on findutils</summary>
  <dl>
    <dt><b>authors</b></dt><dd>GNU Project</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/GPL-3.0-or-later.html" target="_blank">GPL-3.0-or-later</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://www.gnu.org/software/findutils/'>homepage</a>)
      (<a href='https://github.com/ocaml/opam-repository/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/conf-findutils/conf-findutils.1/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>This package can only install if the findutils binary is installed on the system.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/westes/flex'>flex.2</a>
(2) Virtual package relying on GNU flex</summary>
  <dl>
    <dt><b>authors</b></dt><dd>The Flex Project</dd>
    <dt><b>license</b></dt><dd> <a href="https://github.com/westes/flex/blob/master/COPYING" target="_blank">link</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/westes/flex'>homepage</a>)
      (<a href='https://github.com/westes/flex/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/conf-flex/conf-flex.2/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>This package can only install if GNU flex is installed on the system.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/ocaml/opam-repository'>g++.1.0</a>
(1.0) Virtual package relying on the g++ compiler (for C++)</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Francois Berenger</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/GPL-2.0-or-later.html" target="_blank">GPL-2.0-or-later</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/ocaml/opam-repository'>homepage</a>)
      (<a href='https://github.com/ocaml/opam-repository/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/conf-g++/conf-g++.1.0/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>This package can only install if the g++ compiler is installed on the system.</dd>
  </dl>
</details>

<details>
  <summary><a href='http://gmplib.org/'>gmp.3</a>
(3) Virtual package relying on a GMP lib system installation</summary>
  <dl>
    <dt><b>authors</b></dt><dd>nbraud</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/GPL-1.0-or-later.html" target="_blank">GPL-1.0-or-later</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='http://gmplib.org/'>homepage</a>)
      (<a href='https://github.com/ocaml/opam-repository/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/conf-gmp/conf-gmp.3/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>This package can only install if the GMP lib is installed on the system.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://developer.gnome.org/'>gtk3.18</a>
(18) Virtual package relying on GTK+ 3</summary>
  <dl>
    <dt><b>authors</b></dt><dd>The GTK Toolkit</dd>
    <dt><b>license</b></dt><dd>unknown - please clarify with <a href="https://developer.gnome.org/" target="_blank">homepage</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://developer.gnome.org/'>homepage</a>)
      (<a href='https://github.com/garrigue/lablgtk/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/conf-gtk3/conf-gtk3.18/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>This package can only install if GTK+ 3 is installed on the system.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://projects.gnome.org/gtksourceview/'>gtksourceview3.0+2</a>
(0+2) Virtual package relying on a GtkSourceView-3 system installation</summary>
  <dl>
    <dt><b>authors</b></dt><dd>The gtksourceview programmers</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/LGPL-2.1-or-later.html" target="_blank">LGPL-2.1-or-later</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://projects.gnome.org/gtksourceview/'>homepage</a>)
      (<a href='https://github.com/ocaml/opam-repository/issues'>bug reports</a>)
      (<a href='https://github.com/coq/platform/tree/main/opam/opam-repository/packages/conf-gtksourceview3/conf-gtksourceview3.0+2/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>This package can only install if libgtksourceview-3.0-dev is installed on the system.</dd>
  </dl>
</details>

<details>
  <summary><a href='http://www.mpfr.org/'>mpfr.3</a>
(3) Virtual package relying on library MPFR installation</summary>
  <dl>
    <dt><b>authors</b></dt><dd>http://www.mpfr.org/credit.html</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/LGPL-2.0-or-later.html" target="_blank">LGPL-2.0-or-later</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='http://www.mpfr.org/'>homepage</a>)
      (<a href='https://github.com/ocaml/opam-repository/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/conf-mpfr/conf-mpfr.3/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>This package can only install if the MPFR library is installed on the system.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://www.perl.org/'>perl.1</a>
(1) Virtual package relying on perl</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Larry Wall</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/GPL-1.0-or-later.html" target="_blank">GPL-1.0-or-later</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://www.perl.org/'>homepage</a>)
      (<a href='https://github.com/ocaml/opam-repository/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/conf-perl/conf-perl.1/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>This package can only install if the perl program is installed on the system.</dd>
  </dl>
</details>

<details>
  <summary><a href='http://www.freedesktop.org/wiki/Software/pkg-config/'>pkg-config.2</a>
(2) Check if pkg-config is installed and create an opam switch local pkgconfig folder</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Francois Berenger</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/GPL-1.0-or-later.html" target="_blank">GPL-1.0-or-later</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='http://www.freedesktop.org/wiki/Software/pkg-config/'>homepage</a>)
      (<a href='https://github.com/ocaml/opam-repository/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/conf-pkg-config/conf-pkg-config.2/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>This package can only install if the pkg-config package is installednon the system.</dd>
  </dl>
</details>

<details>
  <summary><a href='http://www.gnu.org/software/which/'>which.1</a>
(1) Virtual package relying on which</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Carlo Wood</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/GPL-2.0-or-later.html" target="_blank">GPL-2.0-or-later</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='http://www.gnu.org/software/which/'>homepage</a>)
      (<a href='https://github.com/ocaml/opam-repository/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/conf-which/conf-which.1/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>This package can only install if the which program is installed on the system.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/ocaml-community/cppo'>cppo.1.6.8</a>
(1.6.8) Code preprocessor like cpp for OCaml</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Martin Jambon</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/BSD-3-Clause.html" target="_blank">BSD-3-Clause</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/ocaml-community/cppo'>homepage</a>)
      (<a href='https://github.com/ocaml-community/cppo/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/cppo/cppo.1.6.8/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>Cppo is an equivalent of the C preprocessor for OCaml programs.nIt allows the definition of simple macros and file inclusion.nnCppo is:nn* more OCaml-friendly than cppn* easy to learn without consulting a manualn* reasonably fastn* simple to install and to maintain</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/ocaml-dune/csexp'>csexp.1.5.1</a>
(1.5.1) Parsing and printing of S-expressions in Canonical form</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Quentin Hocquet &lt;mefyl@gruntech.org&gt; - Jane Street Group, LLC - Jeremie Dimino &lt;jeremie@dimino.org&gt;</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/MIT.html" target="_blank">MIT</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/ocaml-dune/csexp'>homepage</a>)
      (<a href='https://github.com/ocaml-dune/csexp/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/csexp/csexp.1.5.1/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>This library provides minimal support for Canonical S-expressionsn[1]. Canonical S-expressions are a binary encoding of S-expressionsnthat is super simple and well suited for communication betweennprograms.nnThis library only provides a few helpers for simple applications. Ifnyou need more advanced support, such as parsing from more fancy inputnsources, you should consider copying the code of this library givennhow simple parsing S-expressions in canonical form is.nnTo avoid a dependency on a particular S-expression library, the onlynmodule of this library is parameterised by the type of S-expressions.nn[1] https://en.wikipedia.org/wiki/Canonical_S-expressions</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/ocaml/dune'>dune-configurator.2.9.1</a>
(2.9.1) Helper library for gathering system configuration</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Jane Street Group, LLC &lt;opensource@janestreet.com&gt;</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/MIT.html" target="_blank">MIT</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/ocaml/dune'>homepage</a>)
      (<a href='https://github.com/ocaml/dune/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/dune-configurator/dune-configurator.2.9.1/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>dune-configurator is a small library that helps writing OCaml scripts thatntest features available on the system, in order to generate config.hnfiles for instance.nAmong other things, dune-configurator allows one to:n- test if a C program compilesn- query pkg-confign- import #define from OCaml header filesn- generate config.h file</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/ocaml/dune'>dune.2.9.1</a>
(2.9.1) Fast, portable, and opinionated build system</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Jane Street Group, LLC &lt;opensource@janestreet.com&gt;</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/MIT.html" target="_blank">MIT</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/ocaml/dune'>homepage</a>)
      (<a href='https://github.com/ocaml/dune/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/dune/dune.2.9.1/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>dune is a build system that was designed to simplify the release ofnJane Street packages. It reads metadata from dune files following anvery simple s-expression syntax.nndune is fast, has very low-overhead, and supports parallel builds onnall platforms. It has no system dependencies; all you need to buildndune or packages using dune is OCaml. You don&apos;t need make or bashnas long as the packages themselves don&apos;t use bash explicitly.nndune supports multi-package development by simply dropping multiplenrepositories into the same directory.nnIt also supports multi-context builds, such as building againstnseveral opam roots/switches simultaneously. This helps maintainingnpackages across several versions of OCaml and gives cross-compilationnfor free.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/mjambon/easy-format'>easy-format.1.3.2</a>
(1.3.2) High-level and functional interface to the Format module of the OCaml standard library</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Martin Jambon</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/BSD-3-Clause.html" target="_blank">BSD-3-Clause</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/mjambon/easy-format'>homepage</a>)
      (<a href='https://github.com/mjambon/easy-format/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/easy-format/easy-format.1.3.2/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>This module offers a high-level and functional interface to the Format module ofnthe OCaml standard library. It is a pretty-printing facility, i.e. it takes asninput some code represented as a tree and formats this code into the mostnvisually satisfying result, breaking and indenting lines of code wherenappropriate.nnInput data must be first modelled and converted into a tree using 3 kinds ofnnodes:nn* atomsn* listsn* labelled nodesnnAtoms represent any text that is guaranteed to be printed as-is. Lists can modelnany sequence of items such as arrays of data or lists of definitions that arenlabelled with something like int main, let x = or x:.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/garrigue/lablgtk'>lablgtk3-sourceview3.3.1.1</a>
(3.1.1) OCaml interface to GTK+ gtksourceview library</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Jacques Garrigue et al., Nagoya University</dd>
    <dt><b>license</b></dt><dd> LGPL with linking exception - see <a href="https://github.com/garrigue/lablgtk" target="_blank">homepage</a> for details</dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/garrigue/lablgtk'>homepage</a>)
      (<a href='https://github.com/garrigue/lablgtk/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/lablgtk3-sourceview3/lablgtk3-sourceview3.3.1.1/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>OCaml interface to GTK+3, gtksourceview3 library.nnSee https://garrigue.github.io/lablgtk/ for more information.</dd>
  </dl>
</details>

<details>
  <summary><a href='http://gitlab.inria.fr/fpottier/menhir'>menhirLib.20210419</a>
(20210419) Runtime support library for parsers generated by Menhir</summary>
  <dl>
    <dt><b>authors</b></dt><dd>François Pottier &lt;francois.pottier@inria.fr&gt; - Yann Régis-Gianas &lt;yrg@pps.univ-paris-diderot.fr&gt;</dd>
    <dt><b>license</b></dt><dd> LGPL-2.0-only WITH OCaml-LGPL-linking-exception - see <a href="http://gitlab.inria.fr/fpottier/menhir" target="_blank">homepage</a> for details</dd>
    <dt><b>links</b></dt><dd>
      (<a href='http://gitlab.inria.fr/fpottier/menhir'>homepage</a>)
      (<a href='https://gitlab.inria.fr/fpottier/menhir/-/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/menhirLib/menhirLib.20210419/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd></dd>
  </dl>
</details>

<details>
  <summary><a href='http://gitlab.inria.fr/fpottier/menhir'>menhirSdk.20210419</a>
(20210419) Compile-time library for auxiliary tools related to Menhir</summary>
  <dl>
    <dt><b>authors</b></dt><dd>François Pottier &lt;francois.pottier@inria.fr&gt; - Yann Régis-Gianas &lt;yrg@pps.univ-paris-diderot.fr&gt;</dd>
    <dt><b>license</b></dt><dd> LGPL-2.0-only WITH OCaml-LGPL-linking-exception - see <a href="http://gitlab.inria.fr/fpottier/menhir" target="_blank">homepage</a> for details</dd>
    <dt><b>links</b></dt><dd>
      (<a href='http://gitlab.inria.fr/fpottier/menhir'>homepage</a>)
      (<a href='https://gitlab.inria.fr/fpottier/menhir/-/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/menhirSdk/menhirSdk.20210419/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd></dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/ocaml/num/'>num.1.4</a>
(1.4) The legacy Num library for arbitrary-precision integer and rational arithmetic</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Valérie Ménissier-Morain Pierre Weis Xavier Leroy</dd>
    <dt><b>license</b></dt><dd> LGPL-2.1-only WITH OCaml-LGPL-linking-exception - see <a href="https://github.com/ocaml/num/" target="_blank">homepage</a> for details</dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/ocaml/num/'>homepage</a>)
      (<a href='https://github.com/ocaml/num/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/num/num.1.4/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd></dd>
  </dl>
</details>

<details>
  <summary><a href='https://ocaml.org'>ocaml-base-compiler.4.10.0</a>
(4.10.0) Official release 4.10.0</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Xavier Leroy and many contributors</dd>
    <dt><b>license</b></dt><dd> LGPL-2.1-or-later WITH OCaml-LGPL-linking-exception - see <a href="https://ocaml.org" target="_blank">homepage</a> for details</dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://ocaml.org'>homepage</a>)
      (<a href='https://github.com/ocaml/opam-repository/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/ocaml-base-compiler/ocaml-base-compiler.4.10.0/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd></dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/janestreet/ocaml-compiler-libs'>ocaml-compiler-libs.v0.12.4</a>
(v0.12.4) OCaml compiler libraries repackaged</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Jane Street Group, LLC</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/MIT.html" target="_blank">MIT</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/janestreet/ocaml-compiler-libs'>homepage</a>)
      (<a href='https://github.com/janestreet/ocaml-compiler-libs/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/ocaml-compiler-libs/ocaml-compiler-libs.v0.12.4/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>This packages exposes the OCaml compiler libraries repackages undernthe toplevel names Ocaml_common, Ocaml_bytecomp, Ocaml_optcomp, ...</dd>
  </dl>
</details>

<details>
  <summary><a href='https://opam.ocaml.org/'>ocaml-config.1</a>
(1) OCaml Switch Configuration</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Louis Gesbert &lt;louis.gesbert@ocamlpro.com&gt; - David Allsopp &lt;david.allsopp@metastack.com&gt;</dd>
    <dt><b>license</b></dt><dd>unknown - please clarify with <a href="https://opam.ocaml.org/" target="_blank">homepage</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://opam.ocaml.org/'>homepage</a>)
      (<a href='https://github.com/ocaml/opam/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/ocaml-config/ocaml-config.1/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>This package is used by the OCaml package to set-up its variables.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/ocaml-ppx/ocaml-migrate-parsetree'>ocaml-migrate-parsetree.1.8.0</a>
(1.8.0) Convert OCaml parsetrees between different versions</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Frédéric Bour &lt;frederic.bour@lakaban.net&gt; - Jérémie Dimino &lt;jeremie@dimino.org&gt;</dd>
    <dt><b>license</b></dt><dd> LGPL-2.1-only WITH OCaml-LGPL-linking-exception - see <a href="https://github.com/ocaml-ppx/ocaml-migrate-parsetree" target="_blank">homepage</a> for details</dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/ocaml-ppx/ocaml-migrate-parsetree'>homepage</a>)
      (<a href='https://github.com/ocaml-ppx/ocaml-migrate-parsetree/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/ocaml-migrate-parsetree/ocaml-migrate-parsetree.1.8.0/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>Convert OCaml parsetrees between different versionsnnThis library converts parsetrees, outcometree and ast mappers betweenndifferent OCaml versions.  High-level functions help making PPXnrewriters independent of a compiler version.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://ocaml.org'>ocaml.4.10.0</a>
(4.10.0) The OCaml compiler (virtual package)</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Xavier Leroy - Damien Doligez - Alain Frisch - Jacques Garrigue - Didier Rémy - Jérôme Vouillon</dd>
    <dt><b>license</b></dt><dd> LGPL-2.1-or-later WITH OCaml-LGPL-linking-exception - see <a href="https://ocaml.org" target="_blank">homepage</a> for details</dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://ocaml.org'>homepage</a>)
      (<a href='https://github.com/ocaml/opam-repository/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/ocaml/ocaml.4.10.0/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>This package requires a matching implementation of OCaml,nand polls it to initialise specific variables like `ocaml:native-dynlink`</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/ocaml/ocamlbuild/'>ocamlbuild.0.14.0</a>
(0.14.0) OCamlbuild is a build system with builtin rules to easily build most OCaml projects.</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Nicolas Pouillard Berke Durak</dd>
    <dt><b>license</b></dt><dd> LGPL-2.1-only WITH OCaml-LGPL-linking-exception - see <a href="https://github.com/ocaml/ocamlbuild/" target="_blank">homepage</a> for details</dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/ocaml/ocamlbuild/'>homepage</a>)
      (<a href='https://github.com/ocaml/ocamlbuild/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/ocamlbuild/ocamlbuild.0.14.0/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd></dd>
  </dl>
</details>

<details>
  <summary><a href='http://projects.camlcity.org/projects/findlib.html'>ocamlfind.1.9.1</a>
(1.9.1) A library manager for OCaml</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Gerd Stolpmann &lt;gerd@gerd-stolpmann.de&gt;</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/MIT.html" target="_blank">MIT</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='http://projects.camlcity.org/projects/findlib.html'>homepage</a>)
      (<a href='https://github.com/ocaml/ocamlfind/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/ocamlfind/ocamlfind.1.9.1/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>Findlib is a library manager for OCaml. It provides a convention hownto store libraries, and a file format (META) to describe thenproperties of libraries. There is also a tool (ocamlfind) forninterpreting the META files, so that it is very easy to use librariesnin programs and scripts.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/backtracking/ocamlgraph/'>ocamlgraph.2.0.0</a>
(2.0.0) A generic graph library for OCaml</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Sylvain Conchon Jean-Christophe Filliâtre Julien Signoles</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/LGPL-2.1-only.html" target="_blank">LGPL-2.1-only</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/backtracking/ocamlgraph/'>homepage</a>)
      (<a href='https://github.com/backtracking/ocamlgraph/issues/new'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/ocamlgraph/ocamlgraph.2.0.0/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>Provides both graph data structures and graph algorithms</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/janestreet/parsexp'>parsexp.v0.14.1</a>
(v0.14.1) S-expression parsing library</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Jane Street Group, LLC</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/MIT.html" target="_blank">MIT</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/janestreet/parsexp'>homepage</a>)
      (<a href='https://github.com/janestreet/parsexp/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/parsexp/parsexp.v0.14.1/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>This library provides generic parsers for parsing S-expressions fromnstrings or other medium.nnThe library is focused on performances but still provide full genericnparsers that can be used with strings, bigstrings, lexing buffers,ncharacter streams or any other sources effortlessly.nnIt provides three different class of parsers:n- the normal parsers, producing [Sexp.t] or [Sexp.t list] valuesn- the parsers with positions, building compact position sequences son  that one can recover original positions in order to report properlyn  located errors at little costn- the Concrete Syntax Tree parsers, produce values of typen  [Parsexp.Cst.t] which record the concrete layout of the s-expressionn  syntax, including commentsnnThis library is portable and doesn&apos;t provide IO functions. To readns-expressions from files or other external sources, you should usenparsexp_io.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/ocaml-ppx/ppx_derivers'>ppx_derivers.1.2.1</a>
(1.2.1) Shared [@@deriving] plugin registry</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Jérémie Dimino</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/BSD-3-Clause.html" target="_blank">BSD-3-Clause</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/ocaml-ppx/ppx_derivers'>homepage</a>)
      (<a href='https://github.com/ocaml-ppx/ppx_derivers/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/ppx_derivers/ppx_derivers.1.2.1/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>Ppx_derivers is a tiny package whose sole purpose is to allownppx_deriving and ppx_type_conv to inter-operate gracefully when linkednas part of the same ocaml-migrate-parsetree driver.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/ocaml-ppx/ppx_deriving'>ppx_deriving.5.1</a>
(5.1) Type-driven code generation for OCaml</summary>
  <dl>
    <dt><b>authors</b></dt><dd>whitequark &lt;whitequark@whitequark.org&gt;</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/MIT.html" target="_blank">MIT</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/ocaml-ppx/ppx_deriving'>homepage</a>)
      (<a href='https://github.com/ocaml-ppx/ppx_deriving/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/ppx_deriving/ppx_deriving.5.1/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>ppx_deriving provides common infrastructure for generatingncode based on type definitions, and a set of useful pluginsnfor common tasks.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/ocaml-ppx/ppx_deriving_yojson'>ppx_deriving_yojson.3.6.1</a>
(3.6.1) JSON codec generator for OCaml</summary>
  <dl>
    <dt><b>authors</b></dt><dd>whitequark &lt;whitequark@whitequark.org&gt;</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/MIT.html" target="_blank">MIT</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/ocaml-ppx/ppx_deriving_yojson'>homepage</a>)
      (<a href='https://github.com/ocaml-ppx/ppx_deriving_yojson/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/ppx_deriving_yojson/ppx_deriving_yojson.3.6.1/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>ppx_deriving_yojson is a ppx_deriving plugin that providesna JSON codec generator.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/ocaml-ppx/ppx_import'>ppx_import.1.8.0</a>
(1.8.0) A syntax extension for importing declarations from interface files</summary>
  <dl>
    <dt><b>authors</b></dt><dd>whitequark &lt;whitequark@whitequark.org&gt;</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/MIT.html" target="_blank">MIT</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/ocaml-ppx/ppx_import'>homepage</a>)
      (<a href='https://github.com/ocaml-ppx/ppx_import/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/ppx_import/ppx_import.1.8.0/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd></dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/janestreet/ppx_sexp_conv'>ppx_sexp_conv.v0.14.1</a>
(v0.14.1) [@@deriving] plugin to generate S-expression conversion functions</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Jane Street Group, LLC</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/MIT.html" target="_blank">MIT</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/janestreet/ppx_sexp_conv'>homepage</a>)
      (<a href='https://github.com/janestreet/ppx_sexp_conv/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/ppx_sexp_conv/ppx_sexp_conv.v0.14.1/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>Part of the Jane Street&apos;s PPX rewriters collection.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/ocaml-ppx/ppx_tools_versioned'>ppx_tools_versioned.5.4.0</a>
(5.4.0) A variant of ppx_tools based on ocaml-migrate-parsetree</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Frédéric Bour &lt;frederic.bour@lakaban.net&gt; - Alain Frisch &lt;alain.frisch@lexifi.com&gt;</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/MIT.html" target="_blank">MIT</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/ocaml-ppx/ppx_tools_versioned'>homepage</a>)
      (<a href='https://github.com/ocaml-ppx/ppx_tools_versioned/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/ppx_tools_versioned/ppx_tools_versioned.5.4.0/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd></dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/ocaml-ppx/ppxlib'>ppxlib.0.15.0</a>
(0.15.0) Standard library for ppx rewriters</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Jane Street Group, LLC</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/MIT.html" target="_blank">MIT</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/ocaml-ppx/ppxlib'>homepage</a>)
      (<a href='https://github.com/ocaml-ppx/ppxlib/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/ppxlib/ppxlib.0.15.0/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>Ppxlib is the standard library for ppx rewriters and other programsnthat manipulate the in-memory reprensation of OCaml programs, a.k.anthe Parsetree.nnIt also comes bundled with two ppx rewriters that are commonly used tonwrite tools that manipulate and/or generate Parsetree values;n`ppxlib.metaquot` which allows to construct Parsetree values using thenOCaml syntax directly and `ppxlib.traverse` which provides variousnways of automatically traversing values of a given type, in particularnallowing to inject a complex structured value into generated code.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/ocaml/ocaml-re'>re.1.10.3</a>
(1.10.3) RE is a regular expression library for OCaml</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Jerome Vouillon - Thomas Gazagnaire - Anil Madhavapeddy - Rudi Grinberg - Gabriel Radanne</dd>
    <dt><b>license</b></dt><dd> LGPL-2.0 with OCaml linking exception - see <a href="https://github.com/ocaml/ocaml-re" target="_blank">homepage</a> for details</dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/ocaml/ocaml-re'>homepage</a>)
      (<a href='https://github.com/ocaml/ocaml-re/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/re/re.1.10.3/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>Pure OCaml regular expressions with:n* Perl-style regular expressions (module Re.Perl)n* Posix extended regular expressions (module Re.Posix)n* Emacs-style regular expressions (module Re.Emacs)n* Shell-style file globbing (module Re.Glob)n* Compatibility layer for OCaml&apos;s built-in Str module (module Re.Str)</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/janestreet/result'>result.1.5</a>
(1.5) Compatibility Result module</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Jane Street Group, LLC</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/BSD-3-Clause.html" target="_blank">BSD-3-Clause</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/janestreet/result'>homepage</a>)
      (<a href='https://github.com/janestreet/result/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/result/result.1.5/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>Projects that want to use the new result type defined in OCaml &gt;= 4.03nwhile staying compatible with older version of OCaml should use thenResult module defined in this library.</dd>
  </dl>
</details>

<details>
  <summary><a href=' '>seq.base</a>
(base) Compatibility package for OCaml&apos;s standard iterator type starting from 4.07.</summary>
  <dl>
    <dt><b>authors</b></dt><dd> </dd>
    <dt><b>license</b></dt><dd>unknown - please clarify with <a href=" " target="_blank">homepage</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href=' '>homepage</a>)
      (<a href='https://caml.inria.fr/mantis/main_page.php'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/seq/seq.base/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd></dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/janestreet/sexplib'>sexplib.v0.14.0</a>
(v0.14.0) Library for serializing OCaml values to and from S-expressions</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Jane Street Group, LLC</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/MIT.html" target="_blank">MIT</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/janestreet/sexplib'>homepage</a>)
      (<a href='https://github.com/janestreet/sexplib/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/sexplib/sexplib.v0.14.0/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>Part of Jane Street&apos;s Core librarynThe Core suite of libraries is an industrial strength alternative tonOCaml&apos;s standard library that was developed by Jane Street, thenlargest industrial user of OCaml.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/janestreet/sexplib0'>sexplib0.v0.14.0</a>
(v0.14.0) Library containing the definition of S-expressions and some base converters</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Jane Street Group, LLC</dd>
    <dt><b>license</b></dt><dd> <a href="https://spdx.org/licenses/MIT.html" target="_blank">MIT</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/janestreet/sexplib0'>homepage</a>)
      (<a href='https://github.com/janestreet/sexplib0/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/sexplib0/sexplib0.v0.14.0/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>Part of Jane Street&apos;s Core librarynThe Core suite of libraries is an industrial strength alternative tonOCaml&apos;s standard library that was developed by Jane Street, thenlargest industrial user of OCaml.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/ocaml/stdlib-shims'>stdlib-shims.0.3.0</a>
(0.3.0) Backport some of the new stdlib features to older compiler</summary>
  <dl>
    <dt><b>authors</b></dt><dd>The stdlib-shims programmers</dd>
    <dt><b>license</b></dt><dd> typeof OCaml system - see <a href="https://github.com/ocaml/stdlib-shims" target="_blank">homepage</a> for details</dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/ocaml/stdlib-shims'>homepage</a>)
      (<a href='https://github.com/ocaml/stdlib-shims/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/stdlib-shims/stdlib-shims.0.3.0/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>Backport some of the new stdlib features to older compiler,nsuch as the Stdlib module.nnThis allows projects that require compatibility with older compiler tonuse these new features in their code.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/ocaml-community/yojson'>yojson.1.7.0</a>
(1.7.0) Yojson is an optimized parsing and printing library for the JSON format</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Martin Jambon</dd>
    <dt><b>license</b></dt><dd>unknown - please clarify with <a href="https://github.com/ocaml-community/yojson" target="_blank">homepage</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/ocaml-community/yojson'>homepage</a>)
      (<a href='https://github.com/ocaml-community/yojson/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/yojson/yojson.1.7.0/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>Yojson is an optimized parsing and printing library for the JSON format.nnIt addresses a few shortcomings of json-wheel including 2x speedup,npolymorphic variants and optional syntax for tuples and variants.nnydump is a pretty-printing command-line program provided with thenyojson package.nnThe program atdgen can be used to derive OCaml-JSON serializers andndeserializers from type definitions.</dd>
  </dl>
</details>

<details>
  <summary><a href='https://github.com/ocaml/Zarith'>zarith.1.12</a>
(1.12) Implements arithmetic and logical operations over arbitrary-precision integers</summary>
  <dl>
    <dt><b>authors</b></dt><dd>Antoine Miné Xavier Leroy Pascal Cuoq</dd>
    <dt><b>license</b></dt><dd>unknown - please clarify with <a href="https://github.com/ocaml/Zarith" target="_blank">homepage</a></dd>
    <dt><b>links</b></dt><dd>
      (<a href='https://github.com/ocaml/Zarith'>homepage</a>)
      (<a href='https://github.com/ocaml/Zarith/issues'>bug reports</a>)
      (<a href='https://opam.ocaml.org/packages/zarith/zarith.1.12/opam'>opam package</a>)
    </dd>
    <dt><b>description</b></dt><dd>The Zarith library implements arithmetic and logical operations overnarbitrary-precision integers. It uses GMP to efficiently implementnarithmetic over big integers. Small integers are represented as Camlnunboxed integers, for speed and space economy.</dd>
  </dl>
</details>

