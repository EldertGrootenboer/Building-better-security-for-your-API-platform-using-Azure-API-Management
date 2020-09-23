using Newtonsoft.Json;
using System;
using System.Configuration;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Input;

namespace AssetManagement
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        private static readonly HttpClient _httpClient = new HttpClient();

        public MainWindow()
        {
            InitializeComponent();
            LoadRepairs();
            Console.WriteLine("Done");
        }

        private void LoadRepairs()
        {
            // Basic authentication
            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Basic", ConfigurationManager.AppSettings["BasicAuthentication"]);
            
            _httpClient.DefaultRequestHeaders.Add("Ocp-Apim-Subscription-Key", ConfigurationManager.AppSettings["ApiManagementSubscriptionKey"]);
            var response = _httpClient.GetAsync($"{ConfigurationManager.AppSettings["AssetManagementApiEndpoint"]}/repairs").Result;

            if(!response.IsSuccessStatusCode)
            {
                MessageBox.Show(response.ReasonPhrase);
                return;
            }

            dynamic repairs = JsonConvert.DeserializeObject(response.Content.ReadAsStringAsync().Result);

            listViewAssets.Items.Clear();

            foreach (var repair in repairs)
            {
                listViewAssets.Items.Add(new { AssetType = repair.asset.assetType, Location = repair.asset.location });
            }
        }

        private void TextBoxTextChanged(object sender, TextChangedEventArgs e)
        {
            buttonSave.IsEnabled = !string.IsNullOrWhiteSpace(textBoxAssetType.Text)
                && !string.IsNullOrWhiteSpace(textBoxEmail.Text)
                && !string.IsNullOrWhiteSpace(textBoxLocation.Text)
                && !string.IsNullOrWhiteSpace(textBoxName.Text)
                && !string.IsNullOrWhiteSpace(textBoxPhoneNumber.Text);
        }

        private void ButtonSaveClick(object sender, RoutedEventArgs e)
        {
            var cursor = Cursor;
            Cursor = Cursors.Wait;

            var repair = new
            {
                asset = new
                {
                    assetType = textBoxAssetType.Text,
                    location = textBoxLocation.Text
                },
                requester = new
                {
                    name = textBoxName.Text,
                    phoneNumber = textBoxPhoneNumber.Text,
                    email = textBoxEmail.Text
                }
            };

            _httpClient.PostAsync($"https://{ConfigurationManager.AppSettings["AssetManagementApiEndpoint"]}/api/Repairs", new StringContent(JsonConvert.SerializeObject(repair), Encoding.UTF8, "application/json"));
            LoadRepairs();

            textBoxAssetType.Text = string.Empty;
            textBoxEmail.Text = string.Empty;
            textBoxLocation.Text = string.Empty;
            textBoxName.Text = string.Empty;
            textBoxPhoneNumber.Text = string.Empty;

            Cursor = cursor;
        }
    }
}