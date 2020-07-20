package cn.utils.jtools.service;

import cn.hutool.http.useragent.UserAgent;
import cn.hutool.http.useragent.UserAgentUtil;
import cn.hutool.json.JSONUtil;
import cn.utils.jtools.utils.FreemarkerTool;
import com.alibaba.fastjson.JSONObject;
import freemarker.template.TemplateException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

/**
 * GeneratorService
 *
 * @author wanglei
 */
@Slf4j
@Service
public class GeneratorServiceImpl implements GeneratorService {

	@Autowired
	private FreemarkerTool freemarkerTool;

	@Override
	public Map<String, String> getResultByParams(Map<String, Object> params) throws IOException, TemplateException {
		//result
		Map<String, String> result = new HashMap<String, String>(32);
		result.put("tableName", params.get("tableName") + "");
		//UI
		result.put("swagger-ui", freemarkerTool.processString("code-generator/ui/swagger-ui.ftl", params));
		result.put("element-ui", freemarkerTool.processString("code-generator/ui/element-ui.ftl", params));
		result.put("bootstrap-ui", freemarkerTool.processString("code-generator/ui/bootstrap-ui.ftl", params));
		//mybatis old
		result.put("controller", freemarkerTool.processString("code-generator/mybatis/controller.ftl", params));
		result.put("service", freemarkerTool.processString("code-generator/mybatis/service.ftl", params));
		result.put("service_impl", freemarkerTool.processString("code-generator/mybatis/service_impl.ftl", params));
		result.put("mapper", freemarkerTool.processString("code-generator/mybatis/mapper.ftl", params));
		result.put("mybatis", freemarkerTool.processString("code-generator/mybatis/mybatis.ftl", params));
		result.put("model", freemarkerTool.processString("code-generator/mybatis/model.ftl", params));
		//jpa
		result.put("entity", freemarkerTool.processString("code-generator/jpa/entity.ftl", params));
		result.put("repository", freemarkerTool.processString("code-generator/jpa/repository.ftl", params));
		result.put("jpacontroller", freemarkerTool.processString("code-generator/jpa/jpacontroller.ftl", params));
		//jdbc template
		result.put("jtdao", freemarkerTool.processString("code-generator/jdbc-template/jtdao.ftl", params));
		result.put("jtdaoimpl", freemarkerTool.processString("code-generator/jdbc-template/jtdaoimpl.ftl", params));
		//beetsql
		result.put("beetlmd", freemarkerTool.processString("code-generator/beetlsql/beetlmd.ftl", params));
		result.put("beetlentity", freemarkerTool.processString("code-generator/beetlsql/beetlentity.ftl", params));
		result.put("beetlentitydto", freemarkerTool.processString("code-generator/beetlsql/beetlentitydto.ftl", params));
		result.put("beetlcontroller", freemarkerTool.processString("code-generator/beetlsql/beetlcontroller.ftl", params));
		//mybatis plus
		result.put("pluscontroller", freemarkerTool.processString("code-generator/mybatis-plus/pluscontroller.ftl", params));
		result.put("plusmapper", freemarkerTool.processString("code-generator/mybatis-plus/plusmapper.ftl", params));
		//util
		result.put("util", freemarkerTool.processString("code-generator/util/util.ftl", params));
		result.put("json", freemarkerTool.processString("code-generator/util/json.ftl", params));
		result.put("xml", freemarkerTool.processString("code-generator/util/xml.ftl", params));
		//sql generate
		result.put("select", freemarkerTool.processString("code-generator/sql/select.ftl", params));
		result.put("insert", freemarkerTool.processString("code-generator/sql/insert.ftl", params));
		result.put("update", freemarkerTool.processString("code-generator/sql/update.ftl", params));
		result.put("delete", freemarkerTool.processString("code-generator/sql/delete.ftl", params));

		//计算,生成代码行数
//        int lineNum = 0;
//        for (Map.Entry<String, String> item: result.entrySet()) {
//            if (item.getValue() != null) {
//                lineNum += StringUtils.countMatches(item.getValue(), "\n");
//            }
//        }
//        log.info("生成代码行数：{}", lineNum);

		//测试环境可自行开启
//		log.info("生成代码数据：{}", result);
		return result;
	}

	@Override
	@Async("taskExecutor")
	public void asyncCilentInfo(HttpServletRequest request) {
		try {
			log.info("记录游客客户端信息:{}", getHeaderJson(request));
			UserAgent ua = UserAgentUtil.parse(request.getHeader("user-agent"));
			log.info("记录游客客户端信息user-agent:" + JSONUtil.toJsonStr(ua));
			log.info("ip:" + getIpAddr(request));
//			request.getHeader("user-agent");
//			request.getHeader("referer");
//			request.getHeader("x-forwarded-for");
		} catch (Exception e) {
			log.error("记录游客客户端信息,发生异常:{}", e);
		}
	}

	/**
	 * 获取请求头信息
	 */
	private String getHeaderJson(HttpServletRequest request) {
		Enumeration<String> headerNames = request.getHeaderNames();
		JSONObject header = new JSONObject();
		while (headerNames.hasMoreElements()) {
			String headerName = headerNames.nextElement();
			header.put(headerName, request.getHeader(headerName));
		}
		return header.toJSONString();
	}

	public String getIpAddr(HttpServletRequest request) {
		if (request == null) {
			return "unknown";
		}
		String ip = request.getHeader("x-forwarded-for");
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("X-Forwarded-For");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("WL-Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("X-Real-IP");
		}

		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getRemoteAddr();
		}

		return "0:0:0:0:0:0:0:1".equals(ip) ? "127.0.0.1" : ip.split(",")[0];
	}
}
