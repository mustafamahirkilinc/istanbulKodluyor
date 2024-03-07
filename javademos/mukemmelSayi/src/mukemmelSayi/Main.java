package mukemmelSayi;

public class Main {

	public static void main(String[] args) {
		//Pozitif tam sayılardan sayının kendisininden başka 
		//pozitif bölenleri toplamı, sayının kendisine eşitse
		//bu sayı mükemmel sayıdır. 
		//Örneğin 6 sayısı: 1, 2, 3 bu sayının 
		//bölenleridir ve tüm bu bölenlerin toplamı, yani 1+2+3, 
		//sayının kendisi 6'ya eşittir.
		//28 -> 1,2,4,7,14 (1+2+4+7+14 = 28)

		int number = 28;
		int total = 0;
		
		for(int i=1; i<number; i++) {
			if(number % i == 0) {
				total = total + i;
			}
		}
		
		if(total == number) {
			System.out.println("Mükemmel sayıdır");
		}
		else {
			System.out.println("Mükemmel sayı değildir");
		}
		
	}

}