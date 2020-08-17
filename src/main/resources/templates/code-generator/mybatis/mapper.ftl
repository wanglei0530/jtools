import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;
import java.util.List;
import ${packageName}.entity.${classInfo.className};

/**
 * @description ${classInfo.classComment} Mapper
 * @author ${authorName}
 * {@link} http://jtools.top
 * @date ${.now?string('yyyy-MM-dd HH:mm:ss')}
 */
@Mapper
@Repository
public interface ${classInfo.className}Mapper {

    /**
    * 新增
    * @author ${authorName}
    * @date ${.now?string('yyyy/MM/dd')}
    **/
    int insert(${classInfo.className} ${classInfo.className?uncap_first});

    /**
    * 批量新增
    * @author ${authorName}
    * @date ${.now?string('yyyy/MM/dd')}
    **/
    int insertBatch(List<${classInfo.className}> list);

    /**
    * 刪除
    * @author ${authorName}
    * @date ${.now?string('yyyy/MM/dd')}
    **/
    int delete(Long id);

    /**
    * 更新
    * @author ${authorName}
    * @date ${.now?string('yyyy/MM/dd')}
    **/
    int update(${classInfo.className} ${classInfo.className?uncap_first});

    /**
    * 查询 根据主键 id 查询
    * @author ${authorName}
    * @date ${.now?string('yyyy/MM/dd')}
    **/
    ${classInfo.className} selectByKey(Long id);


     /**
    * 查询 根据自定义字段
    * @author ${authorName}
    * @date ${.now?string('yyyy/MM/dd')}
    **/
    List<${classInfo.className}> selectByField(@Param("field") String field,@Param("value") String value);

    <#--/**-->
    <#--* 查询 分页查询-->
    <#--* @author ${authorName}-->
    <#--* @date ${.now?string('yyyy/MM/dd')}-->
    <#--**/-->
    <#--List<${classInfo.className}> pageList(int offset,int pagesize);-->

    <#--/**-->
    <#--* 查询 分页查询 count-->
    <#--* @author ${authorName}-->
    <#--* @date ${.now?string('yyyy/MM/dd')}-->
    <#--**/-->
    <#--int pageListCount(int offset,int pagesize);-->

}
