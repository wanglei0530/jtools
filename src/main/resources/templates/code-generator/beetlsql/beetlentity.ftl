import java.io.Serializable;
import lombok.Data;
import java.util.Date;
import java.util.List;
import java.math.BigDecimal;

/**
 * @description ${classInfo.classComment}
 * @author ${authorName}
 * {@link} http://jtools.top
 * @date ${.now?string('yyyy-MM-dd HH:mm:ss')}
 */
@Data
public class ${classInfo.className} implements Serializable {

    private static final long serialVersionUID = 1L;

<#if classInfo.fieldList?exists && classInfo.fieldList?size gt 0>
<#list classInfo.fieldList as fieldItem >
    /**
    * ${fieldItem.fieldComment}
    */
    private ${fieldItem.fieldClass} ${fieldItem.fieldName};

</#list>
    public ${classInfo.className}() {
    }
</#if>

}
