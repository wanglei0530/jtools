package cn.utils.jtools.entity;

import lombok.Data;

/**
 * field info
 *
 * @author wanglei 2018-05-02 20:11:05
 */
@Data
public class FieldInfo {

    private String columnName;
    private String fieldName;
    private String fieldClass;
    private String fieldComment;

}
