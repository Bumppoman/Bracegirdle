module BreadcrumbsHelper
  def breadcrumbs
    breadcrumbs = { 'Dashboard' => dashboard_index_path }
    breadcrumbs = breadcrumbs.merge(@breadcrumbs) rescue breadcrumbs
    return breadcrumbs unless @breadcrumbs == false
  end
end
