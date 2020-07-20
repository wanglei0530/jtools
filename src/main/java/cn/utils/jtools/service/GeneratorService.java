package cn.utils.jtools.service;

import freemarker.template.TemplateException;

import java.io.IOException;
import java.util.Map;

/**
 * GeneratorService
 * @author wanglei
 */
public interface GeneratorService {

    Map<String,String> getResultByParams(Map<String, Object> params) throws IOException, TemplateException;

	void asyncCilentInfo();

}
