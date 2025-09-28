# RFC-005 — CIC-Graph-Interpreter — Interfaces and Components (EN)

## 1. Title and Status

* **ID:** RFC-005
* **Project:** CIC-Graph-Interpreter (CGI)
* **Version:** 0.1-draft
* **Language:** English (export layer)
* **Status:** Draft / under review
* **Date:** [to be filled]
* **Author:** [to be filled]

## 2. Abstract

This RFC specifies the **components and interfaces** of the CIC-Graph-Interpreter (CGI) that realize deterministic graph interpretation, schema- and policy-driven processing, and trust-chain based auditing. Interfaces act as clean contracts between components, enabling modular implementation and testability.

## 3. Core Components

Logical components of the CGI architecture:

* **SnapshotManager:** Loads source files, verifies hashes, and signatures.
* **GraphBuilder:** Constructs the graph from the snapshot.
* **Injector:** Inserts default values, derived nodes, and policy annotations.
* **SchemaValidator:** Verifies node and edge conformance against schemas.
* **PolicyEngine:** Executes explicit rules (allow / degrade / deny).
* **Interpreter:** Performs deterministic traversal and produces an execution plan.
* **AuditLogger:** Records every processing step; append-only, hash-chained log.
* **ResponseAssembler:** Optionally assembles curated context or final responses.

## 4. Interface Specifications

### 4.1 SnapshotManager

```go
Verify(manifestPath string) (SnapshotDigest, error)
Load(snapshotPath string) (Fileset, error)
```

* Ensures the authenticity of the input snapshot.

### 4.2 GraphBuilder

```go
Build(fileset Fileset) (Graph, error)
GetDigest(graph Graph) (GraphDigest, error)
```

* Builds the Graph-IR from the snapshot.
* Computes an unambiguous digest for the entire graph.

### 4.3 Injector

```go
Inject(graph Graph, defaults []DefaultRule) (Graph, error)
Annotate(graph Graph, policies []Policy) (Graph, error)
```

* Injects defaults and derived nodes.
* Applies policy-driven annotations.

### 4.4 SchemaValidator

```go
ValidateNode(node Node, schema Schema) error
ValidateEdge(edge Edge, schema Schema) error
ValidateGraph(graph Graph, schemaSet []Schema) error
```

* Ensures schema compliance.

### 4.5 PolicyEngine

```go
Evaluate(node Node, context Context) Decision
EvaluateEdge(edge Edge, context Context) Decision
AnnotateGraph(graph Graph) (Graph, error)
```

* Makes decisions based on explicit rules.
* Labels nodes and edges (allow / degrade / deny).

### 4.6 Interpreter

```go
Traverse(graph Graph, query Query) (Subgraph, error)
Plan(subgraph Subgraph) (ExecutionPlan, error)
Execute(plan ExecutionPlan) (Result, error)
```

* Deterministically traverses the graph and prepares the execution plan.

### 4.7 AuditLogger

```go
RecordStep(stepName string, inputDigest string, outputDigest string, ruleID string, timestamp time.Time) error
Seal() (AuditDigest, error)
```

* Maintains an append-only, hash-chained audit log.

### 4.8 ResponseAssembler

```go
Assemble(subgraph Subgraph, plan ExecutionPlan) (Response, error)
SignResponse(response Response, keyRef KeyReference) (SignedResponse, error)
```

* Optionally assembles the final response.
* Can sign the response when required.

## 5. Logical Component Diagram

```
[SnapshotManager] --load--> [GraphBuilder] --graph--> [Injector] --graph-->
[SchemaValidator] --validated graph--> [PolicyEngine] --annotated graph-->
[Interpreter] --subgraph/plan--> [ResponseAssembler]
                      |                                  |
                      +------------> [AuditLogger] <----+
```

## 6. Design Principles

1. **Clean contracts:** Every component exposes explicit interfaces.
2. **Deterministic behavior:** Given inputs yield identical outputs.
3. **Auditability:** All critical steps are recorded and hash-chained.
4. **Extensibility:** New schemas or policies can be added with minimal impact.
5. **Testability:** Components can be unit-tested with mocks/stubs.

## 7. Summary

This RFC provides the contractual description of CGI’s components and interfaces, enabling modular implementation and ensuring deterministic, auditable behavior. Further details are defined in implementation notes and the TCK.

---

*This RFC is a draft; refinements and additional code examples are expected during the review process.*
