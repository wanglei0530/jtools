package cn.utils.jtools.entity;

import lombok.Data;

import java.util.List;

/**
 * class info
 *
 * @author wanglei 2018-05-02 20:02:34
 */
@Data
public class ClassInfo {

    private String tableName;
    private String className;
	private String classComment;
	private List<FieldInfo> fieldList;

}