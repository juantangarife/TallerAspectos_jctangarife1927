package uniandes.cupi2.impuestosCarro.jc_tangarife1927.aspects;

public aspect Logger {
	pointcut logger():
		call(* uniandes.cupi2.impuestosCarro.mundo..*(..));

	before(): logger(){
		System.out.println("--- Logger ---");
		System.out.println("*Nombre del método: " + thisJoinPointStaticPart.getSignature().getName());

		Object[] args = thisJoinPoint.getArgs();
		if(args.length > 0) {
			System.out.println("*Parámetros: ");
			for(int i=0;i<args.length;i++) {
				Object arg = args[i];
				System.out.println("  - "+arg.toString()+" ("+ arg.getClass().getName() +")");
			}
		}

		System.out.println("*Target: " + thisJoinPoint.getTarget().getClass().getName());
	}

	after() returning(Object r): logger(){
		System.out.println("*Retorno exitoso: "+r);
		System.out.println("--- End Logger ---");
		System.out.println();
	}
	
	after() throwing(Throwable e): logger(){
		System.out.println("*Excepción: "+e.getClass());
		System.out.println("*Mensaje excepción: "+e.getMessage());
		System.out.println("--- End Logger ---");
	}
}
