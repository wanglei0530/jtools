package cn.utils.jtools.controller;

import cn.hutool.core.util.StrUtil;
import cn.hutool.json.JSONUtil;
import cn.utils.jtools.entity.ReturnT;
import cn.utils.jtools.entity.SignDTO;
import cn.utils.jtools.utils.Md5Utils;
import com.alibaba.fastjson.JSONException;
import com.alibaba.fastjson.JSONObject;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.*;

/**
 * @author ：wanglei
 * @create ：2020-07-29 15:00
 * @description：
 */

@Slf4j
@Controller
@RequestMapping("/sign/")
public class SignController {

	@GetMapping("/")
	public String npsign() {
		return "sign";
	}

	@PostMapping("gensign")
	@ResponseBody
	public ReturnT<Map<String, String>> gensign(@RequestBody SignDTO dto) {
		try {
			log.info("签名参数:{}", dto.toJSON());
			Map<String, String> result = new HashMap<>();
			result.put("sign", signStr(dto.getArea(), dto.getAppKey()));
			return new ReturnT<>(result);
		} catch (Exception e) {
			log.error(e.getMessage(), e);
			return new ReturnT<>(ReturnT.FAIL_CODE, e.getMessage());
		}
	}

	private String signStr(String jsonStr, String key) throws Exception {
		Map<String, String> stringMap = sign(jsonStr, key);
		JSONObject reqJson = JSONObject.parseObject(jsonStr);
		reqJson.put("sign",stringMap.get("sign"));

		StringBuffer stringBuffer = new StringBuffer();
		String a = "// 1. According to the format of key=value, the parameters are sorted in ASCII dictionary order to generate strings:";
		String b = "// 2. Connect merchant key:";
		String c = "// 3. Generate sign and convert it to uppercase:";
		String d = "// 4. Final submission Json:";

		stringBuffer.append(a);
		stringBuffer.append("\n");
		stringBuffer.append(stringMap.get("signStr"));
		stringBuffer.append("\n\n\n");

		stringBuffer.append(b);
		stringBuffer.append("\n");
		stringBuffer.append(stringMap.get("signStrKey"));
		stringBuffer.append("\n\n\n");

		stringBuffer.append(c);
		stringBuffer.append("\n");
		stringBuffer.append("sign=");
		stringBuffer.append(stringMap.get("sign"));
		stringBuffer.append("\n\n\n");

		stringBuffer.append(d);
		stringBuffer.append("\n");
		stringBuffer.append(JSONUtil.formatJsonStr(reqJson.toString()));
		stringBuffer.append("\n\n\n");
		return stringBuffer.toString();
	}

	private Map<String, String> sign(String jsonStr, String key) throws Exception {
		Map<String, String> result = new HashMap<>();
		if (StrUtil.isBlank(jsonStr)) {
			throw new Exception("Cannot be empty！");
		}
		try {
			StringBuilder build = new StringBuilder();
			JSONObject jsonObject = JSONObject.parseObject(jsonStr);
			Set<String> keySet = jsonObject.keySet();
			List<String> keys = new ArrayList<>(keySet);
			Collections.sort(keys);
			for (int i = 0; i < keys.size(); i++) {
				String k = keys.get(i);
				String v = jsonObject.getString(k);
				if (StringUtils.isBlank(k)
						|| StringUtils.isBlank(v)
						|| StringUtils.equals("sign", k)
						|| StringUtils.equals("mqcount", k)) {
					continue;
				}
				build.append(k).append("=").append(v);
				if(i < (keys.size()-1)){
					build.append("&");
				}
			}
			result.put("signStr", build.toString());
			build.append("&key=").append(key);
			String sign = Md5Utils.hash(build.toString()).toUpperCase();
			result.put("signStrKey", build.toString());
			result.put("sign", sign);
			log.info("请求API参数签名字符串:{}", build.toString());
			log.info("请求API参数最后签名:{}", sign);
			return result;
		} catch (JSONException e) {
			throw new JSONException("Parameter is not Json format！");
		} catch (Exception e) {
			log.error("Signature exception:{}", e);
			throw new Exception("Signature exception！");
		}
	}
}
