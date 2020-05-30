package cn.utils.jtools.service;

import freemarker.template.TemplateException;

import java.io.IOException;
import java.util.Map;

/**
 * GeneratorService
 * @author zhengkai.blog.csdn.net
 */
public interface GeneratorService {

    public Map<String,String> getResultByParams(Map<String, Object> params) throws IOException, TemplateException;

}
