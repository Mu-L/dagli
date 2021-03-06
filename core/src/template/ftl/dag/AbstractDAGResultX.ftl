<#import "../common.ftl" as c />
<@c.AutoGeneratedWarning />
package com.linkedin.dagli.dag;

import com.linkedin.dagli.objectio.ObjectReader;
import com.linkedin.dagli.objectio.WrappedObjectReader;
import java.util.Objects;
<#if (arity > 1)>
import com.linkedin.dagli.tuple.${c.tuples[arity]};
import com.linkedin.dagli.objectio.tuple.TupleReader;
</#if>

/**
 * Base class for an object encapsulating the results of executing a DAG.
 *
<#list 1..arity as arg> * @param <${c.ResultGenericArgument(arg)}> the type of result #${arg} of the DAG
</#list>
 */
abstract class <@c.AbstractDAGResult arity /> extends WrappedObjectReader<<@c.ResultTuple arity />> implements <@c.DAGResultInterface arity />, AutoCloseable {
  <#list 1..arity as resultIndex>
  private final ObjectReader<${c.ResultGenericArgument(resultIndex)}> _result${resultIndex};
  </#list>

  <#if (arity > 1)>
  <#list 1..arity as resultIndex>
  @Override
  public ObjectReader<${c.ResultGenericArgument(resultIndex)}> getResult${resultIndex}() {
    return _result${resultIndex};
  }
  </#list>
  </#if>

  /**
   * Create a new DAG result instance from the provided array of {@link ObjectReader}s.
   *
   * @param results an array of length ${arity} providing an {@link ObjectReader} for each of the DAG's outputs.
   */
  @SuppressWarnings("unchecked")
  AbstractDAGResult${arity}(ObjectReader<?>[] results) {
    this(<#list 1..arity as resultIndex>(ObjectReader<${c.ResultGenericArgument(resultIndex)}>) results[${resultIndex - 1}]<#sep>, </#list>);
    assert results.length == ${arity};
  }

  /**
   * Create a new DAG result instance from the provided {@link ObjectReader}s.
   *
<#list 1..arity as index>   * @param results${index} an {@link ObjectReader} for the DAG's ${c.positionNames[index]} output.
</#list>
   */
  AbstractDAGResult${arity}(<#list 1..arity as index>ObjectReader<${c.ResultGenericArgument(index)}> results${index}<#sep>, </#list>) {
    super(<#if (arity > 1)>new TupleReader<>(<#list 1..arity as resultIndex>results${resultIndex}<#sep>, </#list>)<#else>results1</#if>);

    <#list 1..arity as resultIndex>
    _result${resultIndex} = Objects.requireNonNull(results${resultIndex});
    </#list>
  }

  @Override
  public void close() {
    <#list 1..arity as resultIndex>
    _result${resultIndex}.close();
    </#list>
  }
}
