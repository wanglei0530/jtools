package cn.utils.jtools.service;

import freemarker.template.TemplateException;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.Map;

/**
 * GeneratorService
 * @author wanglei
 */
public interface GeneratorService {

    Map<String,String> getResultByParams(Map<String, Object> params) throws IOException, TemplateException;

	void asyncCilentInfo(HttpServletRequest request);

}
