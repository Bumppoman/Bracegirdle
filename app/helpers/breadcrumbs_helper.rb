module BreadcrumbsHelper
  def breadcrumbs
    breadcrumbs = { 'Dashboard' => dashboard_index_path }
    breadcrumbs.merge(@breadcrumbs) rescue breadcrumbs
  end
end
