import java.awt.*;
import java.awt.image.*;
import java.io.*;
import javax.imageio.*;

public class HexColorGenerator extends Component {

	private static final long serialVersionUID = 1L;
	
	//------------------------------------------------------------------------
	//Change velues to import your custom images
	//------------------------------------------------------------------------
	private static String _image_path = "C:/Users/Mino/Desktop/win.png";
	private static String _file_path = "C:/Users/Mino/Desktop/win.txt";
	//------------------------------------------------------------------------
	
	private BufferedImage _img = null;

	public HexColorGenerator() {
		try {
			_img = ImageIO.read(new File(_image_path));
		} catch (IOException e) {
		}

	}

	// Not Used
	public void printPixelARGB(int pixel) {
		int alpha = (pixel >> 24) & 0xff;
		int red = (pixel >> 16) & 0xff;
		int green = (pixel >> 8) & 0xff;
		int blue = (pixel) & 0xff;
		System.out.println("argb: " + alpha + ", " + red + ", " + green + ", "
				+ blue);
	}

	// Not Used
	public String convertToFullHex(int RGBcolor) {

		String tmp = Integer.toHexString(RGBcolor).toUpperCase();
		if (tmp.length() == 1)
			return tmp + "0";
		else
			return tmp;

	}

	public String convertToHex(int RGBcolor) {

		return "" + Integer.toHexString(RGBcolor).toUpperCase().charAt(0);
	}

	public boolean writeFile() {
		try {
			File file = new File(_file_path);
			FileWriter fw = new FileWriter(file);
			BufferedWriter bw = new BufferedWriter(fw);

			int pixel = 0;
			// int alpha = 0;
			int red = 0;
			int green = 0;
			int blue = 0;

			bw.write("CONSTANT sprite_img: sprite := (\n\t");
			for (int i = 0; i < _img.getWidth(); i++) {
				for (int j = 0; j < _img.getHeight(); j++) {

					pixel = _img.getRGB(i, j);

					red = (pixel >> 16) & 0xff;
					green = (pixel >> 8) & 0xff;
					blue = (pixel) & 0xff;

					bw.write("X\"" + convertToHex(red) + convertToHex(green)
							+ convertToHex(blue) + "\"");

					if (i >= _img.getWidth()-1 && j >= _img.getHeight()-1) {
						bw.write("\n");
					} else {
						bw.write(",");
						if (j == _img.getWidth() - 1)
							bw.write("\n\t");
					}
				}
			}

			bw.write(");\n");

			bw.flush();
			bw.close();

			return true;
		} catch (IOException e) {
			e.printStackTrace();
			return false;
		}
	}

	public static void main(String[] args) {

		HexColorGenerator hcg = new HexColorGenerator();
		if (hcg.writeFile())
			System.out.println("SUCCESS!!!\n");
		else
			System.err.println("FAILED!!!\n");
	}
}