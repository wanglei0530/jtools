import java.util.Map;

/**
 * @description ${classInfo.classComment}
 * @author ${authorName}
 * {@link} http://jtools.top
 * @date ${.now?string('yyyy-MM-dd HH:mm:ss')}
 */
public interface ${classInfo.className}Service {

    /**
    * 新增
    */
    public int insert(${classInfo.className} ${classInfo.className?uncap_first});

    /**
    * 删除
    */
    public int delete(Long id);

    /**
    * 更新
    */
    public int update(${classInfo.className} ${classInfo.className?uncap_first});

    /**
    * 根据主键 id 查询
    */
    public ${classInfo.className} selectByKey(Long id);

}
