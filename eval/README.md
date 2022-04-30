# Evaluation

This file explains how to reproduce the experiments.

## Setup

We have conducted all of our experiments on a Linux system (Debian stretch), but
other systems may also work, possibly with some adjustments. Relevant development
tools (Java, Maven, Gradle, g++, etc.) need to be installed as required.
The steps for preparing the necessary software are as follows.

### Lazy

For the approach LAZY, prepare the lazy ASP solver Alpha by creating a jar
from its [repository](https://github.com/alpha-asp/Alpha):
```
git clone https://github.com/alpha-asp/Alpha.git
cd Alpha/
git checkout b081a01c2fb540e6a7a4ae2e34e68b18f15a7389
./gradlew build
./gradlew bundledJar
```
This produces a standalone jar under `build/libs/alpha-bundled.jar`, and we refer
to this jar as `lazy.jar` below.

### DLVcomp

For the approach DLVcomp, we have used the static version of [DLV-complex](https://www.mat.unical.it/dlv-complex),
and installed all required runtime dependencies (esp. 32bit libraries).
We refer to the executable binary as `dlv-comp`.

### ExRules

For the approach ExRules, prepare the code of this prototype, which is a
fork of the Java library [Rulewerk](https://github.com/knowsys/rulewerk):
```
cd ../rulewerk
./build-vlog-library.sh
mvn clean install -DskipTests
cd rulewerk-examples
mvn clean compile assembly:single
```
This produces a standalone jar under `rulewerk/rulewerk-examples/target/rulewerk-asp-jar-with-dependencies.jar`,
which we refer to as `ex-rules.jar`. The script `build-vlog-library.sh` is prepared for a Unix shell and can
be run on Linux and MacOS. Windows systems can be used too, but the C++ compilation instructions must be adapted
to that environment. There are also pre-compiled VLog binaries for Windows that are used by default if the
build step is omitted, but note that using a different version can affect performance and compatibility with our
code (which was forked from the main branch).

Moreover, [clasp](https://potassco.org/clasp/) should be installed.


## Running experiments

For running the experiments, we assume that the ontology files are located in the directory `ontologies/`,
logic programs under `programs/`, and systems under `reasoners/`.
With `<ontology-id>` we refer to the ontology for which the experiment should be run.
We used the command `time` to measure how long the experiments for an ontology took and `timeout 900` to ensure the timeout of 15 minutes.
Moreover, we redirected the outputs of the commands to files to avoid, especially for large answer sets, performance limitations due to writing to the command line.

### ExRules
For task (A), you can run:
```
java -Xmx16g -jar reasoners/ex-rules.jar programs/classification.rls programs/transitive-reduct.rls ontologies/<ontology-id> -g reduction.aspif -f sc_reduct 2
clasp -n 1 reduction.aspif
```

For task (B), you can run:
```
java -Xmx16g -jar reasoners/ex-rules.jar programs/classification.rls programs/max-antichains.rls ontologies/<ontology-id> -g reduction.aspif -f in_anti 1
clasp -n 5 reduction.aspif
```

### DLVcomp
For task (A), you can run:
```
reasoners/dlv-comp -silent programs/classification.dl programs/transitive-reduct.dl ontologies/<ontology-id> -nofdcheck -filter=sc_reduct -n=1
```

For task (B), you can run:
```
reasoners/dlv-comp -silent programs/classification.dl programs/max-antichains.dl ontologies/<ontology-id> -nofdcheck -filter=in_anti -n=5
```

### LAZY
For the classification of ontologies, you can run:
```
java -Xmx16g -jar reasoners/lazy.jar -i programs/classification.lp -i ontologies/<ontology-id> -f sc -n 1
```

Even though LAZY could not solve (A) and (B) on our evaluation system, the following commands can be used, in principle, for them.

For task (A), you can run:
```
java -Xmx16g -jar reasoners/lazy.jar -i programs/classification.lp -i ontologies/transitive-reduct.dl -i ontologies/<ontology-id> -f sc_reduct -n 1
```

For task (B), you can run:
```
java -Xmx16g -jar reasoners/lazy.jar -i programs/classification.lp -i ontologies/max-antichains.dl -i ontologies/<ontology-id> -f in_anti -n 1
```
