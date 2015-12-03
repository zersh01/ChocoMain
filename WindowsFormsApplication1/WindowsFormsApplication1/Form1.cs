using System;
using System.IO;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Xml;
using System.Xml.Linq;
using System.Text.RegularExpressions;
using Microsoft.VisualBasic;



namespace WindowsFormsApplication1
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            tabControl1.Visible = false;
            textBox12.Visible = false;
            button11.Visible = false;
            button12.Visible = false;
            
        }


        private void openNuspecToolStripMenuItem_Click(object sender, EventArgs e)
        {
            SaveFileDialog savefile = new SaveFileDialog();
            var Path = "";
            savefile.DefaultExt = ".nuspec";
            if (savefile.ShowDialog() == DialogResult.OK)
            {
                tabControl1.Visible = true;
                textBox12.ReadOnly = false;

                Path = System.IO.Path.GetDirectoryName(savefile.FileName);

                //глобальное поле для использования в кнопках
                label16.Text = savefile.FileName;
                label14.Text = Path;
                System.IO.Directory.CreateDirectory(label14.Text + "\\tools");
            
                //многострочная подсказка для поля зависимостей
                
                ToolTip deptooltip = new ToolTip();

                string DependsToolTip = @"Add dependency one per line.
                Use separator ; for name and version.  Example: 
                windows;7
                linux;2.2";
                //убираем лишние табы
                string DepToolTip = Regex.Replace(DependsToolTip, " {16}", " ");

                deptooltip.SetToolTip(textBox12, DepToolTip);
                //многострочная подсказка для поля зависимостей/////
                
                //Если файл новый, то очищаем все поля(вдруг был открыт какойто другой файл)

                textBox1.Text = "";
                textBox2.Text = "";
                textBox3.Text = "";
                textBox4.Text = "";
                textBox5.Text = "";
                textBox6.Text = "";
                textBox7.Text = "";
                textBox8.Text = "";
                textBox9.Text = "";
                textBox10.Text = "";
                textBox11.Text = "";
                textBox12.Text = "";
                richTextBox1.Text = "";
                richTextBox2.Text = "";
                richTextBox3.Text = "";
                richTextBox4.Text = "";

            }


        }

        private void exitToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            Close();
        }

      


        private void exitToolStripMenuItem_Click(object sender, EventArgs e)
        {
            // MessageBox.Show("Выбран файл: " + xmlDocument);
            //выбираем файл
            OpenFileDialog openFileDialog1 = new OpenFileDialog();
            //стартовый диск (в релизе изменить на С)
            openFileDialog1.InitialDirectory = "C:\\";
            openFileDialog1.Filter = "nuspec files (*.nuspec)|*.nuspec|All files (*.*)|*.*";
            openFileDialog1.FilterIndex = 1;
            openFileDialog1.RestoreDirectory = true;

            //активируем элементы
            tabControl1.Visible = true;

            /*
            многстрочная подсказка для зависимостей
              */

            ToolTip deptooltip = new ToolTip();

            string DependsToolTipText = @"Add dependency one per line.
                Use separator ; for name and version.  Example: 
                windows;7
                linux;2.2";
            //убираем лишние табы
            string DepToolTip = Regex.Replace(DependsToolTipText, " {16}", " ");

            deptooltip.SetToolTip(textBox12, DepToolTip);


          
            //получаем путь к каталогу
            var Path = "";
            if (openFileDialog1.ShowDialog() == DialogResult.OK)
                Path = System.IO.Path.GetDirectoryName(openFileDialog1.FileName);
            //глобальное поле для использования в кнопках
            label16.Text = openFileDialog1.FileName;
            label14.Text = Path;
            {
                try
                {
                    //считываем xml
                    XDocument xmlDocument = XDocument.Load(openFileDialog1.FileName);

                    //преобразуем из var в стринг для удаления xmlns
                    string strNumber = System.Convert.ToString(xmlDocument);
                    string strXMLPattern = @"xmlns(:\w+)?=""([^""]+)""|xsi(:\w+)?=""([^""]+)""";
                    strNumber = Regex.Replace(strNumber, strXMLPattern, "");
                    //обратно в вар для удобства     
                    var xmlDoc = XDocument.Parse(strNumber);

                    //теперь парсим по элементно xml
                    var packageInfo = from metadata in xmlDoc.Descendants("metadata")
                                      select new
                                      {
                                          id = metadata.Element("id").Value,
                                          title = metadata.Element("title").Value,
                                          version = metadata.Element("version").Value,
                                          authors = metadata.Element("authors").Value,
                                          owners = metadata.Element("owners").Value,
                                          summary = metadata.Element("summary").Value,
                                          description = metadata.Element("description").Value,
                                          projectUrl = metadata.Element("projectUrl").Value,
                                          tags = metadata.Element("tags").Value,
                                          copyright = metadata.Element("copyright").Value,
                                          licenseUrl = metadata.Element("licenseUrl").Value,
                                          releaseNotes = metadata.Element("releaseNotes").Value,
                                          iconUrl = metadata.Element("iconUrl").Value,
                                          requireLicenseAcceptance = metadata.Element("requireLicenseAcceptance").Value
                                      };
                    //заполняем текстовые поля на форме nuspec
                    foreach (var loadInfo in packageInfo)
                    {
                        textBox1.Text = loadInfo.id;
                        textBox2.Text = loadInfo.tags;
                        textBox3.Text = loadInfo.title;
                        textBox4.Text = loadInfo.version;
                        textBox5.Text = loadInfo.authors;
                        textBox6.Text = loadInfo.owners;
                        textBox7.Text = loadInfo.summary;
                        textBox8.Text = loadInfo.iconUrl;
                        textBox9.Text = loadInfo.projectUrl;
                        textBox10.Text = loadInfo.licenseUrl;
                        textBox11.Text = loadInfo.copyright;
                        richTextBox1.Text = loadInfo.description;
                        richTextBox2.Text = loadInfo.releaseNotes;
                        checkBox1.Checked = bool.Parse(loadInfo.requireLicenseAcceptance);

                    }



                    //заполняем chocolateyInstall
                    string instalfile = Path + "\\tools\\chocolateyInstall.ps1";

                    using (StreamReader sr = new StreamReader(instalfile))
                    {
                        richTextBox3.Text = sr.ReadToEnd();
                    }
                    //заполняем chocolateyUninstall
                    string uninstalfile = Path + "\\tools\\chocolateyUninstall.ps1";

                    using (StreamReader sr = new StreamReader(uninstalfile))
                    {
                        richTextBox4.Text = sr.ReadToEnd();
                    }

                }
                catch (Exception ex)
                {
                    MessageBox.Show("Error: Could not read file from disk. Original error: " + ex.Message);
                }

            }

        }

        private void openFileDialog1_FileOk(object sender, CancelEventArgs e)
        {

        }

        private void button1_Click_1(object sender, EventArgs e)
        {
            tabControl1.SelectedIndex = 1;
        }

        private void button2_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedIndex = 2;
        }

        private void button3_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedIndex = 0;
        }

        private void button9_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedIndex = 1;
        }

        private void exitToolStripMenuItem2_Click(object sender, EventArgs e)
        {
            Close();
        }

        private void button7_Click(object sender, EventArgs e)
        {
            button6_Click(button6, null);
        }
        private void button8_Click(object sender, EventArgs e)
        {
            button6_Click(button6, null);
        }

        private void button6_Click(object sender, EventArgs e)
        {
            //КНОПКА Create
            //реализуем сохранение unspec

            //путь к фалу:
            string Filename = label16.Text;
            //заголовок xml и тестовая строка
            string defaulttext = "<?xml version=\"1.0\" encoding=\"utf-8\"?> ";
            string commentUTF = "<!-- Do not remove this test for UTF-8: if “Ω” doesn’t appear as greek uppercase omega letter enclosed in quotation marks, you should use an editor that supports UTF-8, not this one. -->";
            //открываем на запись файл
            using (StreamWriter sw = new StreamWriter(Filename, false, System.Text.Encoding.UTF8))
            //генерируем структуру xml файла
            {

                XNamespace aw = "http://schemas.microsoft.com/packaging/2010/07/nuspec.xsd";
                XElement root = new XElement(aw + "package");
                XElement child1 = new XElement(aw + "metadata",

                    new XElement(aw + "id", textBox1.Text),
                    new XElement(aw + "title", textBox3.Text),
                    new XElement(aw + "version", textBox4.Text),
                    new XElement(aw + "authors", textBox5.Text),
                    new XElement(aw + "owners", textBox6.Text),
                    new XElement(aw + "summary", textBox7.Text),
                    new XElement(aw + "description", richTextBox1.Text),
                    new XElement(aw + "projectUrl", textBox9.Text),
                    new XElement(aw + "tags", textBox2.Text),
                    new XElement(aw + "copyright", textBox11.Text),
                    new XElement(aw + "licenseUrl", textBox10.Text),
                    new XElement(aw + "requireLicenseAcceptance", checkBox1.Checked),
                    new XElement(aw + "releaseNotes", richTextBox2.Text),
                    new XElement(aw + "iconUrl", textBox8.Text)
                
                    );

                XElement child2 = new XElement(aw + "files"
                    );
                XElement child3 = new XElement(aw + "file");

                child3.SetAttributeValue("src", "tools\\**");
                child3.SetAttributeValue("target", "tools");


                //Добавляем зависимости/////////////////////

                /*
                <dependencies>
                    <dependency id="phantomjs" version="2.0.0" />
                    <dependency id="python2" version="2.7.10" />
                </dependencies>
                */

                if (checkBox2.Checked)
                {
                    
                    XElement child4 = new XElement(aw + "dependencies");

                    
                    String[] deparray = textBox12.Text.Split(new String[] { "\r\n" }, StringSplitOptions.RemoveEmptyEntries);
                    

                    foreach (var depstring in deparray)
                    {
                        XElement child5 = new XElement(aw + "dependency");
                        string[] deps = depstring.Split(';');

                        for (int i = 0; i <= deps.Length; i++) ;

                        child5.SetAttributeValue("id", deps[0]);
                        child5.SetAttributeValue("version", deps[1]);
                        child4.Add(child5);

                    }

                    child1.Add(child4);
                    child2.Add(child3);
                    
                    root.Add(child1,child2);
                }else
                {
                    //если зависимостей нет то nuspec формируем так
                    child2.Add(child3);
                    root.Add(child1,child2);
                }
                //пишем в файл
                sw.WriteLine(defaulttext);
                sw.WriteLine(commentUTF);
                sw.WriteLine(root);
            }
            //реализуем сохранение chocolateyInstall.ps1
            string Path = label14.Text;
            string instalfile = Path + "\\tools\\chocolateyInstall.ps1";
            using (StreamWriter si = new StreamWriter(instalfile, false, System.Text.Encoding.UTF8))
            {
                si.WriteLine(richTextBox3.Text);
            }

            //реализуем сохранение chocolateyUninstall.ps1
            string uninstalfile = Path + "\\tools\\chocolateyUninstall.ps1";
            using (StreamWriter su = new StreamWriter(uninstalfile, false, System.Text.Encoding.UTF8))
            {
                su.WriteLine(richTextBox4.Text);
            }
            
            //создаем пакет
            //create package
            
            string command = "cd " + label14.Text +" & choco pack " + label16.Text + " & pause "+ "& exit";
            System.Diagnostics.Process.Start("cmd.exe", @"/K"  + command );

            System.Threading.Thread.Sleep(5000);

            //MessageBox.Show("Saving");

            /* Если создание успешно и создался файл как в шаблоне: qip2012.4.0.9380.nupkg
                активируем формы для установки/удаления 
                */

            string PackageFile = label14.Text + "\\" + textBox1.Text + "." + textBox4.Text + ".nupkg";
            if (System.IO.File.Exists(PackageFile))
            {
                button11.Visible = true;
                button12.Visible = true;
            }
            else
            {
                button11.Visible = false;
                button12.Visible = false;
            }
        }

        private void enterToolStripMenuItem_Click(object sender, EventArgs e)
        {
            String apikey = Microsoft.VisualBasic.Interaction.InputBox("Enter Your API Key", "API Key ", "", 200, 200);
            if (apikey.Length > 0)
            {
                string chocokey = "choco apiKey -k " + apikey + " -source https://chocolatey.org/ & pause & exit";
                System.Diagnostics.Process.Start("cmd.exe", @"/K" + chocokey);
            }
            else {
                MessageBox.Show("API Key may not be null (Canceled)");
            }
        }

        private void checkBox2_CheckedChanged(object sender, EventArgs e)
        {
            if (checkBox2.Checked)
            {
                textBox12.Visible = true;
            }
            else {
                textBox12.Visible = false;
            }
        }

        private void button5_Click(object sender, EventArgs e)
        {
            //Environment.NewLine

            string NoteInstall = "_templates\\chocolatey\\tools\\chocolateyInstall.ps1";

            using (StreamReader sr = new StreamReader(NoteInstall))
            {
                richTextBox3.Text = sr.ReadToEnd();
            }

        }

        private void button4_Click(object sender, EventArgs e)
        {

            string TemplateExeInstall = @"$packageName = '_REPLACE_'
                $installerType = 'EXE' 
                $url = 'http://download.template.ru/Setup.exe'
                $silentArgs = '/VERYSILENT /NORESTART /TASKS=""desktopicon,startmenuicon""' 
                $validExitCodes = @(0) 
                Install-ChocolateyPackage ""$packageName"" ""$installerType"" ""$silentArgs"" ""$url""   -validExitCodes $validExitCodes";
            
            //Remove Tabulation
            string TemplateExeInstall1 = Regex.Replace(TemplateExeInstall, " {16}", " ");
            
            richTextBox3.Text = TemplateExeInstall1;
        }

        private void button10_Click(object sender, EventArgs e)
        {

            string TemplateUninstall = @"$packageName = '_REPLACE_'
                $fileType = 'exe'
                $silentArgs = '/VERYSILENT /NORESTART'
 
                $uninstallString = (Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\_REPLACE_').UninstallString

                if ($uninstallString -ne "") {
                    Uninstall-ChocolateyPackage $packageName $fileType $silentArgs $uninstallString
                }";

            //Remove Tabulation
            string TemplateUninstall1 = Regex.Replace(TemplateUninstall, " {16}", " ");

            richTextBox4.Text = TemplateUninstall1;

        }

        private void uploadPackageToChocolateyToolStripMenuItem_Click(object sender, EventArgs e)
        {
            //choco push deskpins.1.30.nupkg
            

            string UploadPackage = "choco push " + label14.Text+ "\\" +  textBox1.Text + "." + textBox4.Text +".nupkg & pause & exit";
            System.Diagnostics.Process.Start("cmd.exe", @"/K" + UploadPackage);
            //MessageBox.Show(UploadPackage);

        }
        //install menu
        private void installThisPackageToolStripMenuItem_Click(object sender, EventArgs e)
        {
            
            string InstallString = "choco install " + textBox1.Text + " -source " + label14.Text + " -y -force -version " + textBox4.Text + " & pause & exit";
            System.Diagnostics.Process.Start("cmd.exe", @"/K" + InstallString);
            //MessageBox.Show(InstallString);

        }
        //uninstallmenu
        private void uninstallThisPackageToolStripMenuItem_Click(object sender, EventArgs e)
        {
            string UninstallString = "choco uninstall " + textBox1.Text + " -a -y & pause & exit";
            System.Diagnostics.Process.Start("cmd.exe", @"/K" + UninstallString);
        }

        private void helpToolStripMenuItem_Click(object sender, EventArgs e)
        {
            System.Diagnostics.Process.Start("https://github.com/chocolatey/choco/wiki/CreatePackages");
        }

        private void button11_Click(object sender, EventArgs e)
        {

            string InstallString = "choco install " + textBox1.Text + " -source " + label14.Text + " -y -force -version " + textBox4.Text + " & pause & exit";
            System.Diagnostics.Process.Start("cmd.exe", @"/K" + InstallString);
        }

        private void button12_Click(object sender, EventArgs e)
        {
            string UninstallString = "choco uninstall " + textBox1.Text + " -a -y & pause & exit";
            System.Diagnostics.Process.Start("cmd.exe", @"/K" + UninstallString);
        }

        private void aboutToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            Form2 AboutForm = new Form2();
            AboutForm.ShowDialog();
        }
    }
}
