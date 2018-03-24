package uniandes.cupi2.impuestosCarro.jc_tangarife1927.aspects;

public aspect Mailer {
	private static final double MAILER_TAX_LIMIT = 2000000;
	
	pointcut mailer():
		call(public double calcularPago(boolean, boolean, boolean));

	after() returning(double r): mailer(){
		if(r > MAILER_TAX_LIMIT) {
			System.out.println("--- Mailer ---");
			System.out.println(r);
			System.out.println("--- End Mailer ---");
			System.out.println();
		}
	}
}
