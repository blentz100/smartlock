let ThemeToggle = {
    mounted() {
        const setTheme = (theme) => {
            document.documentElement.setAttribute("data-theme", theme);
            localStorage.setItem("theme", theme); // persist user choice
        };

        // Restore saved theme from localStorage if exists
        const saved = localStorage.getItem("theme");
        if (saved) {
            setTheme(saved);
        } else {
            // Otherwise, use OS preference
            const prefersDark = window.matchMedia("(prefers-color-scheme: dark)").matches;
            setTheme(prefersDark ? "dark" : "light");

            // Listen for OS changes only if no saved theme
            window.matchMedia("(prefers-color-scheme: dark)").addEventListener("change", (e) => {
                setTheme(e.matches ? "dark" : "light");
            });
        }

        // Toggle theme on click
        this.el.addEventListener("click", () => {
            console.log("inside click"); // for debugging
            const current = document.documentElement.getAttribute("data-theme");
            setTheme(current === "dark" ? "light" : "dark");
        });
    }
};

export default ThemeToggle;