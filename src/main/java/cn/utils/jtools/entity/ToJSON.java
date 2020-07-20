package cn.utils.jtools.entity;

import com.alibaba.fastjson.JSON;

/**
 * 转 Json 字符串
 *
 * @author wanglei
 */
public interface ToJSON {

    default String toJSON(){
        return JSON.toJSONString(this);
    }
}
