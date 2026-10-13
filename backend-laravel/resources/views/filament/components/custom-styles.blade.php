<style>
    /* =========================================================
       RERE PETSHOP - ENHANCED ADMIN & SIDEBAR STYLING
       ========================================================= */

    /* Sleek Custom Scrollbar for Sidebar */
    .fi-sidebar-nav::-webkit-scrollbar {
        width: 4px;
    }
    .fi-sidebar-nav::-webkit-scrollbar-track {
        background: transparent;
    }
    .fi-sidebar-nav::-webkit-scrollbar-thumb {
        background: rgba(156, 163, 175, 0.25);
        border-radius: 9999px;
    }
    .fi-sidebar-nav::-webkit-scrollbar-thumb:hover {
        background: rgba(245, 158, 11, 0.4);
    }

    /* Sidebar Background & Border Enhancement */
    .fi-sidebar {
        border-right: 1px solid rgba(229, 231, 235, 0.8) !important;
    }
    .dark .fi-sidebar {
        border-right: 1px solid rgba(31, 41, 55, 0.8) !important;
    }

    /* Sidebar Header */
    .fi-sidebar-header {
        border-bottom: 1px solid rgba(243, 244, 246, 0.8) !important;
        padding-top: 0.875rem !important;
        padding-bottom: 0.875rem !important;
    }
    .dark .fi-sidebar-header {
        border-bottom: 1px solid rgba(31, 41, 55, 0.6) !important;
    }

    /* Navigation Group Headers */
    .fi-sidebar-group-label {
        font-size: 0.6875rem !important;
        font-weight: 700 !important;
        text-transform: uppercase !important;
        letter-spacing: 0.08em !important;
        color: rgb(156 163 175) !important;
    }
    .dark .fi-sidebar-group-label {
        color: rgb(107 114 128) !important;
    }

    /* Navigation Item Buttons */
    .fi-sidebar-item-btn {
        border-radius: 0.5rem !important;
        font-weight: 500 !important;
        transition: background-color 0.15s ease, color 0.15s ease !important;
        margin-block: 0.125rem !important;
    }

    /* Navigation Item Hover State */
    .fi-sidebar-item-btn:hover {
        background-color: rgba(243, 244, 246, 0.9) !important;
    }
    .dark .fi-sidebar-item-btn:hover {
        background-color: rgba(31, 41, 55, 0.7) !important;
    }

    /* Active Navigation Item State */
    .fi-sidebar-item.fi-active .fi-sidebar-item-btn {
        background: linear-gradient(90deg, rgba(245, 158, 11, 0.15) 0%, rgba(245, 158, 11, 0.04) 100%) !important;
        border-left: 3px solid #f59e0b !important;
        padding-left: calc(0.75rem - 3px) !important;
        font-weight: 600 !important;
    }
    .dark .fi-sidebar-item.fi-active .fi-sidebar-item-btn {
        background: linear-gradient(90deg, rgba(245, 158, 11, 0.25) 0%, rgba(245, 158, 11, 0.06) 100%) !important;
        border-left: 3px solid #fbbf24 !important;
    }

    /* Active Icon Glow */
    .fi-sidebar-item.fi-active .fi-sidebar-item-icon {
        color: #f59e0b !important;
    }
    .dark .fi-sidebar-item.fi-active .fi-sidebar-item-icon {
        color: #fbbf24 !important;
    }

    /* Badges in Navigation */
    .fi-sidebar-item .fi-badge {
        font-size: 0.6875rem !important;
        font-weight: 700 !important;
        padding: 0.125rem 0.5rem !important;
        border-radius: 9999px !important;
        letter-spacing: 0.02em !important;
    }

    /* Topbar Refinement */
    .fi-topbar {
        border-bottom: 1px solid rgba(229, 231, 235, 0.8) !important;
        backdrop-filter: blur(12px) !important;
        -webkit-backdrop-filter: blur(12px) !important;
    }
    .dark .fi-topbar {
        border-bottom: 1px solid rgba(31, 41, 55, 0.8) !important;
    }

    /* Global Content Polish */
    .fi-section {
        border-radius: 0.875rem !important;
    }

    /* Dashboard Stat Cards */
    .fi-wi-stats-overview-stat {
        border-radius: 0.875rem !important;
        transition: box-shadow 0.2s ease !important;
    }
    .fi-wi-stats-overview-stat:hover {
        box-shadow: 0 4px 12px -2px rgba(0, 0, 0, 0.06);
    }
    .dark .fi-wi-stats-overview-stat:hover {
        box-shadow: 0 4px 12px -2px rgba(0, 0, 0, 0.35);
    }
</style>
