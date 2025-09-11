    Here's your content formatted with markdown, using `###` for subheadings and `*` for list items:

    ---

    ### * Updated C# Using Statements

    #### * Project-Specific

    *   Changed `using Xamarin.Forms;` → `using Microsoft.Maui.Controls;`
    *   Changed `using Xamarin.Essentials;` → `using Microsoft.Maui.Essentials;`
    *   Changed `using Xamarin.Forms.Xaml;` → `Microsoft.Maui.Controls.Xaml;`
    *   Updated `Device.BeginInvokeOnMainThread` → `MainThread.BeginInvokeOnMainThread`

    #### * Generic

    *   `using Xamarin.Essentials;` → `using Microsoft.Maui.Essentials;`
    *   `using Xamarin.Forms;` → `using Microsoft.Maui.Controls;`
    *   `using Xamarin.Forms.Xaml;` → `using Microsoft.Maui.Controls.Xaml;`

    ### * Updated XAML Using Statements

    #### * MainPage.xaml

    **Original:**

    ```xml
    <ContentPage xmlns="http://xamarin.com/schemas/2014/forms"
                 xmlns:x="http://schemas.microsoft.com/winfx/2009/xaml"
                 x:Class="ResillentConstruction.MainPage"
                 xmlns:ios="clr-namespace:Xamarin.Forms.PlatformConfiguration.iOSSpecific;assembly=Xamarin.Forms.Core" xmlns:resillentconstruction="clr-namespace:ResillentConstruction"
                 ios:Page.UseSafeArea="true">
    ```

    **To:**

    ```xml
    <ContentPage xmlns="http://schemas.microsoft.com/dotnet/2021/maui"
                 xmlns:x="http://schemas.microsoft.com/winfx/2009/xaml"
                 x:Class="ResillentConstruction.MainPage"
                 xmlns:ios="clr-namespace:Microsoft.Maui.Controls.PlatformConfiguration.iOSSpecific;assembly=Microsoft.Maui.Controls" xmlns:resillentconstruction="clr-namespace:ResillentConstruction"
                 ios:Page.UseSafeArea="true">
    ```

    *   `xmlns:ios="clr-namespace:Xamarin.Forms.PlatformConfiguration.iOSSpecific;assembly=Xamarin.Forms.Core"`
        *   **To:** `xmlns:ios="clr-namespace:Microsoft.Maui.Controls.PlatformConfiguration.iOSSpecific;assembly=Microsoft.Maui.Controls"`

    ### * `.csproj` File Updates

    ```xml
        <ItemGroup>
            <PackageReference Include="Microsoft.Maui.Controls" Version="$(MauiVersion)" />
            <PackageReference Include="Microsoft.Maui.Controls.Compatibility" Version="$(MauiVersion)" />
            <PackageReference Include="Microsoft.Maui.Essentials" Version="$(MauiVersion)" />
            <PackageReference Include="Microsoft.Extensions.Logging.Debug" Version="8.0.1" />
            <PackageReference Include="Newtonsoft.Json" Version="13.0.3" />
            <PackageReference Include="sqlite-net-pcl" Version="1.8.116" />
        </ItemGroup>
    ```

    ### * Folder Copy All

    *   `androidfolder/Resources/drawable/` --> `mainfolder/Resources/Images`
    *   `androidfolder/Assets` --> `mainfolder/Resources/Raw`
    *   Other folder files: 1 to 1
    *   Images naming: no uppercase

    ### * Command Line

    *   `dotnet restore`

    ### * App Specific: CERS

    *   `App.xaml.cs` file. The problem is on line 48 where `Device.BeginInvokeOnMainThread` is being used, which is deprecated in .NET MAUI. This should be replaced with `MainThread.BeginInvokeOnMainThread`.

    ### * `F10` `App.cs`

    *   Create window

    ### * Update MAUI Project File with Necessary Dependencies and Configurations

    #### * App Specific: CERS

    ```xml
    <!--  update the MauiProgram.cs file to register the SQLite service with dependency injection -->
            <PackageReference Include="Newtonsoft.Json" Version="13.0.3" />
            <PackageReference Include="sqlite-net-pcl" Version="1.8.116" />
            <PackageReference Include="Microsoft.Maui.Essentials" Version="$(MauiVersion)" />
    ```

    ### * Remove Xamarin Imports with MAUI Equivalent

    *   `using System.Reflection.Emit;` --> `""` (remove)
    *   `Device.BeginInvokeOnMainThread` --> `MainThread.BeginInvokeOnMainThread`
    *   `Color.FromHex` --> `Color.FromArgb`
    *   `using System.Web;` --> `using System.Net;`

    *   Fix the `HttpUtility.UrlEncode` calls since we removed the `System.Web` reference. Let me replace them with the .NET equivalent:
    *   Replace all the `HttpUtility.UrlEncode` calls with `WebUtility.UrlEncode` in the `HitServices.cs` file.

    #### * Summary of Changes Made

    1.  **Fixed `Microsoft.Maui.Essentials` version downgrade warning**
        *   Updated the package reference from version `8.0.91` to `8.0.100` in `CERS.csproj` to match the version required by other MAUI components.
    2.  **Resolved `System.Web.HttpUtility` package reference issue**
        *   Removed the `System.Web.HttpUtility` package reference (which doesn't exist for .NET MAUI).
        *   Replaced `using System.Web;` with `using System.Net;` in both `App.xaml.cs` and `HitServices.cs`.
        *   Updated all `HttpUtility.UrlEncode()` calls to use `WebUtility.UrlEncode()` instead.
    3.  **Fixed `Microsoft.Maui.Essentials` namespace reference errors**
        *   The `Microsoft.Maui.Essentials` using statement is now properly resolved with the correct package version.
        *   All Essentials APIs like `Preferences`, `MainThread`, and `Connectivity` should now work correctly.

    ### * Fix `Microsoft.Maui.Essentials` Namespace Issues

    *   `<PackageReference Include="Microsoft.Maui.Essentials" Version="8.0.91" />`

    ### * Fix Duplicate `App` Class Definitions

    ### * Fix `Label` Ambiguous Reference

    ### * Fix `Color` Property Issues

    ### * Fix Duplicate XAML Attributes

    ### * Fix the Remaining `Device.BeginInvokeOnMainThread` Calls to Use the MAUI Equivalent `MainThread.BeginInvokeOnMainThread`. Let Me Update These:

    ### * Update Any Remaining Xamarin References in Your Code Files

    Your project should now compile successfully! The key changes ensure:

    *   ✅ All dependencies are properly configured
    *   ✅ Platform-specific SQLite implementations work with MAUI's dependency injection
    *   ✅ Color and threading APIs use MAUI equivalents
    *   ✅ Namespace references are updated for MAUI

    ### * Don't Override Files

    1.  Resolve `System.Web.HttpUtility` package reference issue
    2.  Fix `Microsoft.Maui.Essentials` version downgrade warning
    3.  Fix `'Microsoft.Maui.Essentials'` namespace reference errors

    *   ! The code is using `Preferences`, `MainThread`, and `Connectivity` from `Microsoft.Maui.Essentials`, but the namespace reference is incorrect. In .NET MAUI, these are now in separate namespaces. Let me fix this:
    *   Use `using Microsoft.Maui.Controls;`

    ### * Hotkey

    *   `ctrl+shift+c` (with all row)

    *   `Font` property is deprecated in .NET MAUI. It should be replaced with `FontSize`. Let me fix this:

    *   The problem is that in .NET 8 MAUI, the `Microsoft.Maui.Essentials` namespace doesn't exist as a separate namespace anymore. The Essentials APIs are now directly available in the main MAUI namespaces.

    *   **Severity Code Description Project File Line Source**
        Error (active) XFC0009 No property, BindableProperty, or event found for "Font", or mismatching type between value and property. CERS (net8.0-android), CERS (net8.0-ios), CERS (net8.0-maccatalyst), CERS (net8.0-windows10.0.19041.0) C:\Users\Parth\Desktop\2025\CERS-baseone\CERS\ViewExpenditureDetailsPage.xaml 100 Build

    *   **What You Should NOT Copy:**
        *   `MainActivity.cs` - MAUI uses a different base class and simplified approach
        *   Most Resources - MAUI handles resources differently through the main project
        *   `Android_SQLite.cs` - Already converted to `MauiSQLite.cs` with proper MAUI patterns

    *   I found the issue! The problem is that your database classes are using `DependencyService.Get<ISQLite>()` (Xamarin.Forms pattern) but you've registered the service using MAUI's dependency injection (`builder.Services.AddSingleton`). These two systems don't work together.

    *   Remove all Xamarin patterns

    *   The error has changed - now it's a `TypeInitializationException` for the `CERS.App` class, which means there's an exception being thrown during static field initialization in your `App` class.

    *   I found the issue! The problem is in the static field initialization in your `App` class. Lines 23, 26, and 28 are creating database instances as static fields:

        ```csharp
        public static UserDetailsDatabase userDetailsDatabase = new UserDetailsDatabase();
        public static SavePreferenceDatabase savePreferenceDatabase = new SavePreferenceDatabase();
        public static LanguageMasterDatabase languageMasterDatabase = new LanguageMasterDat
        ```

    *   These database constructors are trying to use `DependencyService.Get<ISQLite>()` before the MAUI application has fully initialized, causing the crash.

    *   When the `UserDetailsDatabase` constructor ran, it tried to call `DependencyService.Get<ISQLite>()`, but the service wasn't registered yet.

    *   **Moved database initialization to the constructor:**
        *   Changed static fields to declarations only (no initialization)
        *   Added database instance creation in the `App()` constructor after `InitializeComponent()`
        *   This ensures databases are created after MAUI's dependency injection is fully initialized

    *   The app should now start successfully without the `TypeInitializationException`. The database instances will be created at the right time when the dependency service is available.

    *   The error is a XAML parsing issue: Cannot convert "Default" into `Microsoft.Maui.Graphics.Color` at position 24:10 in your `App.xaml` file.

    *   I found the issue! On line 24, you have `<Color x:Key="Light_Frame_Background_Color">Default</Color>`. The value "Default" is not a valid color in .NET MAUI.

    #### * `App.xaml`

    *   **Changed line 24 in `App.xaml`:**
        *   From: `<Color x:Key="Light_Frame_Background_Color">Default</Color>`
        *   To: `<Color x:Key="Light_Frame_Background_Color">Transparent</Color>`
    *   The app should now start successfully without the XAML parsing exception. The `Transparent` color is a valid color value that will work properly with your frame styling.

    ### * Fix `SQLitePCLRaw.provider.dynamic_cdecl` Assembly Loading Issue

    #### * Fix Applied

    *   **Added to `CERS.csproj`:**
        ```xml
        <PackageReference Include="SQLitePCLRaw.bundle_green" Version="2.1.6" />
        ```

    ### * Key Differences (Xamarin.Forms vs. .NET MAUI)

    The code worked in Xamarin.Forms because Xamarin.Forms had a different initialization sequence and dependency resolution system.

    #### * Xamarin.Forms:
    *   `DependencyService` was initialized early in the application lifecycle
    *   Static field initialization happened after the dependency service was ready
    *   The `[assembly: Dependency(typeof(Android_SQLite))]` attribute registered services at compile time
    *   Platform-specific implementations were available immediately

    #### * .NET MAUI:
    *   Uses Microsoft's dependency injection container which initializes later
    *   Static fields are initialized when the type is first accessed (before MAUI startup)
    *   Services are registered in `MauiProgram.CreateMauiApp()` which runs after static initialization
    *   There's a timing mismatch between when static fields initialize and when services become available

    #### * Why the Timing Issue Exists:
    *   Static field initialization happens when the `App` class is first referenced
    *   MAUI dependency injection setup happens in `MauiProgram.CreateMauiApp()`
    *   App constructor runs after DI is configured
    *   In Xamarin.Forms, the `DependencyService` was a simpler, earlier-initialized system that was available during static field initialization. MAUI's more sophisticated DI container requires the full application context to be set up first.

    *   That's why moving the database initialization from static fields to the constructor fixed the issue - it ensures the database objects are created after MAUI's dependency injection system is fully initialized and the services are available.

    ### * In `App.xaml.cs` Define `DB_NAME = "CERS.db "`

    *   `var databasePath = Path.Combine(FileSystem.AppDataDirectory, "CERS.db");`
        *   **to** `var databasePath = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), ResillentConstruction.App.DB_Name);`

    ### * Open Old and New Reference Code in `agneticApp`

    ### * Find Database Tables and Check What Mobile Numbers Exist for Login Testing

    Based on the code analysis, the login system works by calling a web API to check user types and authenticate users. The app doesn't store test mobile numbers locally - it validates them against a remote server.

    #### * How the Login System Works:
    *   User enters mobile number → App calls `CheckUserType_Get(mobileNo)` API
    *   API returns user type → "Candidate", "Agent", or "Observor"
    *   App calls appropriate login API → `userlogin_Get()` or `observorlogin_Get()`
    *   If user exists → App calls `GetOtp()` to send OTP
    *   User enters OTP → App calls `checkotp_Get()` to verify

    #### * To Test Login:
    Since this connects to a live API server, you need actual registered mobile numbers from the CERS system database. The app doesn't have hardcoded test numbers.

    #### * Options:
    *   Check with system admin for test mobile numbers
    *   Look at API documentation for test credentials
    *   Check server logs for existing registered numbers
    *   Create test data through the web admin panel (if available)

    #### * The mobile number validation requires:
    *   10 digits
    *   Must start with 6, 7, 8, or 9
    *   Only numeric characters
    *   Without access to the server database or test credentials, you'll need to contact the system administrator to get valid mobile numbers for testing the login functionality.

    ### * Find the Database Connection URL/Base URL in the Code to Help User Connect to Database

    *   `baseurl = "http://10.146.2.8/CERSWebApi/"`

    ### * Create Mock/Fake API Responses to Bypass Network Calls for Testing