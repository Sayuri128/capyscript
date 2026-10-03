class ExecutionBudget {
  final int maxLoopIterations;
  final int maxCallDepth;
  int _loopIterations = 0;

  ExecutionBudget({
    this.maxLoopIterations = 10000000,
    this.maxCallDepth = 1000,
  });

  ExecutionBudget fresh() => ExecutionBudget(
      maxLoopIterations: maxLoopIterations, maxCallDepth: maxCallDepth);

  void countLoopIteration() {
    if (++_loopIterations > maxLoopIterations) {
      throw Exception(
          "Execution budget exceeded: more than $maxLoopIterations loop iterations");
    }
  }

  void checkCallDepth(int depth) {
    if (depth > maxCallDepth) {
      throw Exception(
          "Execution budget exceeded: call depth above $maxCallDepth");
    }
  }
}
