package ibsheet;

import java.lang.reflect.Constructor;
import java.lang.reflect.Method;
import java.sql.Connection;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ClassBroker {
	public static Object getInstance(String className) throws Throwable {
        Object instance = null;
        try
        {
            Class dsClass = Class.forName(className);
            Class[] parameterTypes = new Class[]{};
            Constructor constuctor = dsClass.getConstructor(parameterTypes);
            instance = constuctor.newInstance(new Object[] { });
        }
        catch (Throwable e)
        {
            throw e;
        }
        
        return instance;
	}
	
	public static Object getInstance(String className, HttpServletRequest request) throws Throwable {
        Object instance = null;
        try
        {
            Class dsClass = Class.forName(className);
            Class[] parameterTypes = new Class[] {HttpServletRequest.class };
            Constructor constuctor = dsClass.getConstructor(parameterTypes);
            instance = constuctor.newInstance(new Object[] { request });
        }
        catch (Throwable e)
        {
        	throw e;
        }
        
        return instance;
	}

	public static Object getInstance(String className, HttpServletRequest request,HttpServletResponse response) throws Throwable {
        Object instance = null;
        try
        {
            Class dsClass = Class.forName(className);
            Class[] parameterTypes = new Class[] {HttpServletRequest.class , HttpServletResponse.class };
            Constructor constuctor = dsClass.getConstructor(parameterTypes);
            instance = constuctor.newInstance(new Object[] { request ,response});
        }
        catch (Throwable e)
        {
        	throw e;
        }
        
        return instance;
	}
	
	
	public static Object getInstance(String className, HttpServletRequest request, Connection conn) throws Throwable {
        Object instance = null;
        try
        {
            Class dsClass = Class.forName(className);
            Class[] parameterTypes = new Class[] { Connection.class, HttpServletRequest.class };
            Constructor constuctor = dsClass.getConstructor(parameterTypes);
            instance = constuctor.newInstance(new Object[] { conn, request });
        }
        catch (Throwable e)
        {
        	throw e;
        }
        
        return instance;
	}

	public static Object getInstance(String className, HttpServletRequest request, HttpServletResponse response, Connection conn) throws Throwable {
        Object instance = null;
        try
        {
            Class dsClass = Class.forName(className);
            Class[] parameterTypes = new Class[] { Connection.class, HttpServletRequest.class ,HttpServletResponse.class};
            Constructor constuctor = dsClass.getConstructor(parameterTypes);
            instance = constuctor.newInstance(new Object[] { conn, request ,response });
        }
        catch (Throwable e)
        {
        	throw e;
        }
        
        return instance;
	}
	
	public static Object getInstance(String className, Object[] constructParameters) throws Throwable {
        Object instance = null;
        try
        {
            Class dsClass = Class.forName(className);
            Constructor constuctor = dsClass.getConstructor(ClassBroker.getParameterTypes(constructParameters));
            instance = constuctor.newInstance(constructParameters);
        }
        catch (Throwable e)
        {
        	throw e;
        }
        
        return instance;
	}
	
	public static Object invoke(Object controller, String methodName, Object[] parameters) throws Throwable {
		Object objReturn = null;
		try{
            Class ctlClass = controller.getClass();
			Method method = ctlClass.getMethod(methodName, ClassBroker.getParameterTypes(parameters));
			objReturn = method.invoke(controller, parameters);
		}
		catch(Throwable e) {
			throw e;
		}
		
		return objReturn;
	}
	
	public static Class[] getParameterTypes(Object[] parameters) throws Throwable {
		Class[] parameterTypes = null;
		try {
			parameterTypes = new Class[parameters.length];
			int size = parameters.length;
			for (int i = 0; i < size; i++) {
				parameterTypes[i] = parameters[i].getClass();
			}
		}
		catch (Throwable e) {
			throw e;
		}
		
		return parameterTypes;
	}
}
