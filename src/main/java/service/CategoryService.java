package service;

import java.util.List;

import dao.CategoryDAO;
import model.Category;

public class CategoryService {

    private final CategoryDAO categoryDAO;

    public CategoryService() {
        this.categoryDAO = new CategoryDAO();
    }

    public List<Category> getAllCategories() {
        return categoryDAO.getAllCategories();
    }

    public Category getCategoryById(int categoryId) {
        return categoryDAO.getCategoryById(categoryId);
    }

    public String getCategoryNameById(int categoryId) {
        return categoryDAO.getCategoryNameById(categoryId);
    }
}